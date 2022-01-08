#!/usr/bin/env python3

import os,sys,subprocess

# note: change this to True when *not* on windows
_native = False

# native()/bash()/exec() utility functions
def native(cmd):
    print(cmd)
    retval = os.system(cmd)
    if retval != 0:
        sys.exit(retval)

def bash(cmd):
    tmp = []
    tmp += ['c:/mozilla-build/msys/bin/bash.exe', '-c', cmd]
    print(cmd)
    retval = subprocess.run(tmp).returncode
    if retval != 0:
        sys.exit(retval)

def exec(cmd):
    if _native:
        return native(cmd)
    return bash(cmd)

#
# windows specific actions
#

def win_before_build():
    exec('cp -v assets/mozconfig.windows librewolf-$(cat version)/mozconfig')

#
# main functions
#

def fetch():
    exec('wget -q -O version https://gitlab.com/librewolf-community/browser/source/-/raw/main/version')
    exec('wget -q -O source_release https://gitlab.com/librewolf-community/browser/source/-/raw/main/release')
    exec('wget -O librewolf-$(cat version)-$(cat source_release).source.tar.gz https://gitlab.com/librewolf-community/browser/source/-/jobs/artifacts/main/raw/librewolf-$(cat version)-$(cat source_release).source.tar.gz?job=build-job')

def build():
    
    exec('rm -rf librewolf-$(cat version)')
    exec('tar xf librewolf-$(cat version)-$(cat source_release).source.tar.gz')
    
    win_before_build()
    
    with open('version','r') as file:
        version = file.read().rstrip()
        os.chdir('librewolf-{}'.format(version))
        
        exec('MACH_USE_SYSTEM_PYTHON=1 ./mach build')
        exec('MACH_USE_SYSTEM_PYTHON=1 ./mach package')



def artifacts():
    bash('# you gotta figure that out from the previous ./build.py')
    pass


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
