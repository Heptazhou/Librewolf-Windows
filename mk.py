#!/usr/bin/env python3

import os,sys,subprocess

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

_native = False # modify this when needed
def exec(cmd):
    if _native:
        return native(cmd)
    return bash(cmd)



# main functions

def fetch():
    exec('rm -rf version release')
    exec('wget -q -O version https://gitlab.com/librewolf-community/browser/source/-/raw/main/version')
    exec('wget -q -O release https://gitlab.com/librewolf-community/browser/source/-/raw/main/release')
    exec('rm -f librewolf-$(cat version)-$(cat release).source.tar.gz')
    exec('wget -O librewolf-$(cat version)-$(cat release).source.tar.gz https://gitlab.com/librewolf-community/browser/source/-/jobs/artifacts/main/raw/librewolf-$(cat version)-$(cat release).source.tar.gz?job=build-job')

def build():
    exec('rm -rf librewolf-$(cat version)')
    exec('tar xf librewolf-$(cat version)-$(cat release).source.tar.gz')
    with open('version','r') as file:
        version = file.read().rstrip()
        os.chdir('librewolf-{}'.format(version))    
        exec('./mach build')
        exec('./mach package')

def artifact():
    bash('# you gotta figure that out from the previous ./build.py')
    pass

# parse commandline for commands

help_msg = '''
Use: ./mk.py <command> ...

commands:
  fetch
  build
  artifact

'''

done_something = False

for arg in sys.argv:
    if arg == 'fetch':
        fetch()
        done_something = True
    elif arg == 'build':
        build()
        done_something = True
    elif arg == 'artifact':
        artifact()
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





subprocess.run(['C:\\cygwin64\\bin\\bash.exe', '-l', 'RunModels.scr'], 
               stdin=vin, stdout=vout,
               cwd='C:\\path\\dir_where_RunModels\\')






exec('ls -la')













old_help = '''
$ ./build.py
# Use:

     build.py [<options>] clean | all | <targets> | <utilities>

# Options:

    -n,--no-execute            - print commands, don't execute them
    -l,--no-librewolf          - skip LibreWolf specific stages.
    -x,--cross                 - crosscompile from linux, implies -t win
    -s,--src <src>             - release,nightly,tor-browser,gecko-dev
                                 (default=release)
    -t,--distro <distro>       - deb,rpm,win,osx (default=win)
    -T,--token <private_token> - private token used to upload to gitlab.com
    -3,--i386                  - build 32-bit
    -P,--settings-pane         - build with the experimental settings pane

# Targets:

    all        - all steps from fetch to producing setup.exe
    clean      - clean everything, including extracted/fetched sources
    veryclean  - clean like above, and also remove build artifacts.

    fetch               - wget or hg clone or git pull
    extract             - when using wget, extract the archive.
    lw_do_patches       - [librewolf] patch the source
    build               - build the browser
    lw_post_build       - [librewolf] insert our settings
    package             - package the browser into zip/apk
    lw_artifacts        - [librewolf] build setup.exe

# Utilities:

    update_submodules   - git update submodules
    upload              - upload the build artifacts to gitlab.com

    git_init    - put the source folder in a .git repository
    reset       - use git/mercurial to revert changes to a clean state

    deps_deb    - install dependencies with apt
    deps_rpm    - install dependencies with dnf
    deps_pkg    - install dependencies on freebsd

    rustup      - update rust
    mach_env    - create mach environment


'''

