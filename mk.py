#!/usr/bin/env python3

import os,sys,subprocess

# native()/bash()/exec() utility functions
def native(cmd):
    sys.stdout.flush()
    print(cmd)
    sys.stdout.flush()
   
    retval = os.system(cmd)
    if retval != 0:
        sys.exit(retval)

_no_exit = False
def bash(cmd):
    tmp = []
    tmp += ['c:/mozilla-build/msys/bin/bash.exe', '-c', cmd]
    sys.stdout.flush()
    print(cmd)
    sys.stdout.flush()
    
    retval = subprocess.run(tmp).returncode
    if _no_exit:
        return
    if retval != 0:
        sys.exit(retval)

_native = False
_no_exit = False
def exec(cmd):
    if _native:
        return native(cmd)
    return bash(cmd)

def patch(patchfile):
    cmd = "patch -p1 -i {}".format(patchfile)
    sys.stdout.flush()
    print("\n*** -> {}".format(cmd))
    sys.stdout.flush()
    
    retval = os.system(cmd)
    if retval != 0:
        sys.stdout.flush()
        print("fatal error: patch '{}' failed".format(patchfile))
        sys.stdout.flush()
        sys.exit(retval)



#
# main functions
#


def fetch():
    print('mk.py: fetch(): Disabled due to "artifacts" now has priority.')
    sys.exit(1)
    
    exec('wget -q -O version https://gitlab.com/librewolf-community/browser/source/-/raw/main/version')
    exec('wget -q -O source_release https://gitlab.com/librewolf-community/browser/source/-/raw/main/release')
    exec('wget -O librewolf-$(cat version)-$(cat source_release).source.tar.gz https://gitlab.com/librewolf-community/browser/source/-/jobs/artifacts/main/raw/librewolf-$(cat version)-$(cat source_release).source.tar.gz?job=build-job')

def build():
    print('mk.py: build(): Disabled due to "artifacts" now has priority.')
    sys.exit(1)
    
    exec('rm -rf librewolf-$(cat version)')
    exec('tar xf librewolf-$(cat version)-$(cat source_release).source.tar.gz')
    
    with open('version','r') as file:
        version = file.read().rstrip()
        os.chdir('librewolf-{}'.format(version))

        # patches
        exec('cp -v ../assets/mozconfig.windows mozconfig')
        patch('../assets/package-manifest.patch')
        
        exec('MACH_USE_SYSTEM_PYTHON=1 ./mach build')
        _no_exit = True
        exec('MACH_USE_SYSTEM_PYTHON=1 ./mach package')
        _no_exit = False
        exec('cp -v obj-x86_64-pc-mingw32/dist/firefox-{}.en-US.win64.zip ..'.format(version))
        os.chdir('..')



def artifacts():
    bash('# guide - you gotta figure this out from the previous ./build.py')
    pass

    with open('version','r') as file:
        version = file.read().rstrip()
        exec('cp -v librewolf-{}/obj-x86_64-pc-mingw32/dist/firefox-{}.en-US.win64.zip .'.format(version,version))

        print('mk.py:artifacts(): done.')

#
# parse commandline for commands
#

help_msg = '''
Use: ./mk.py <command> ...

commands:
  fetch
  build
  artifacts

'''

done_something = False

for arg in sys.argv:
    if arg == 'fetch':
        fetch()
        done_something = True
    elif arg == 'build':
        build()
        done_something = True
    elif arg == 'artifacts':
        artifacts()
        done_something = True
    else:
        if arg == sys.argv[0]:
            pass
        else:
            print(help_msg)
            sys.exit(1)


        
if done_something:
    sys.exit(0)
    
print(help_msg)
sys.exit(1)
