#!/usr/bin/python3

#
# pybuild.py - try move functionality away from that too big of a script.
#

import optparse
import sys
import os

parser = optparse.OptionParser()

parser.add_option('-x', '--cross',  dest='cross_compile', default=False, action="store_true")
parser.add_option('-s', '--src',    dest='src',           default='release')
parser.add_option('-t', '--distro', dest='distro',        default='win')

options, remainder = parser.parse_args()

                
#print("[debug] ----------")
#print("[debug] --cross  = ", options.cross_compile)
#print("[debug] --src    = ", options.src)
#print("[debug] --distro = ", options.distro)
#print("[debug] ----------")




def enter_srcdir():
        pass
def leave_srcdir():
        pass
def exec(cmd):
        # print command on stdout and sys.exit(1) on errors
        pass








# Targets:
def execute_fetch():
        print("[debug] doing target -> fetch")
def execute_extract():
        print("[debug] doing target -> extract")
def execute_lw_do_patches():
        print("[debug] doing target -> lw_do_patches")
def execute_build():
        enter_srcdir()
        cmd = "./mach build"
        exec(cmd)
        leave_srcdir()
def execute_lw_post_build():
        print("[debug] doing target -> lw_post_build")
def execute_package():
        enter_srcdir()
        cmd = "./mach package"
        exec(cmd)
        leave_srcdir()
def execute_lw_artifacts():
        print("[debug] doing target -> lw_artifacts")
        


# Main targets:
def execute_all():
        execute_fetch()
        execute_extract()
        execute_lw_do_patches()
        execute_build()
        execute_lw_post_build()
        execute_package()
        execute_lw_artifacts() 
def execute_clean():
        print("[debug] doing target -> clean")




        
# Utilities:
def execute_git_subs():
        print("[debug] doing target -> git_subs")

def execute_git_init():
        print("[debug] doing target -> git_init")
def execute_git_reset():
        print("[debug] doing target -> git_reset")

def execute_deps_deb():
        print("[debug] doing target -> deps_deb")
def execute_deps_rpm():
        print("[debug] doing target -> deps_rpm")
def execute_deps_pkg():
        print("[debug] doing target -> deps_pkg")

def execute_rustup():        
        print("[debug] doing target -> rustup")
def execute_mach_env():
        print("[debug] doing target -> mach_env")






# main commandline interpretation
if len(remainder)>0:
        if not options.src in ['release','nightly','tor-browser']:
                print("error: option --src invalid value")
                sys.exit(1)
        if not options.distro in ['deb','rpm', 'win']:
                print("error: option --distro invalid value")
                sys.exit(1)

        for arg in remainder:
                if arg == 'all':
                        execute_all()
                elif arg == 'clean':
                        execute_clean()
                        
                # Targets:
                        
                elif arg == 'fetch':
                        execute_fetch()
                elif arg == 'extract':
                        execute_extract()
                elif arg == 'lw_do_patches':
                        execute_lw_do_patches()
                elif arg == 'build':
                        execute_build()
                elif arg == 'lw_post_build':
                        execute_lw_post_build()
                elif arg == 'package':
                        execute_package()
                elif arg == 'lw_artifacts':
                        execute_lw_artifacts()

                # Utilities
                        
                elif arg == 'git_subs':
                        execute_git_subs()
                        
                elif arg == 'git_init':
                        execute_git_init()
                elif arg == 'git_reset':
                        execute_git_reset()
                        
                elif arg == 'deps_deb':
                        execute_deps_deb()
                elif arg == 'deps_rpm':
                        execute_deps_rpm()
                elif arg == 'deps_pkg':
                        execute_deps_pkg()
                        
                elif arg == 'rustup':
                        execute_rustup()
                elif arg == 'mach_env':
                        execute_mach_env()
                        
                else:
                        print("error: unknown command on command line: ", arg)
                        sys.exit(1)
else:
        # Print help message
        print("""# Use: 

     pybuild [<options>] clean | all | <targets>

# Options:

    -x,--cross              - build windows setup.exe from linux
    -s,--src <src>          - release,nightly,tor-browser
                              (default=release)
    -t,--distro <distro>    - deb,rpm,win (default=win)

# Targets:

    all      - all steps from fetch to producing setup.exe
    clean    - clean everything, includeing extracted/fetched sources

    fetch               - wget or hg clone or git pull
    extract             - nop if not wget
    lw_do_patches       - [librewolf] patch the source
    build               - build the browser
    lw_post_build       - [librewolf] insert our settings
    package             - package the browser into zip/apk
    lw_artifacts        - [librewolf] build setup.exe

# Utilities:

    git_subs    - git update submodules

    git_init    - put the source folder in a .git reposity
    git_reset   - reset the source folder from the .git repo

    deps_deb    - install dependencies with apt
    deps_rpm    - install dependencies with dnf
    deps_pkg    - install dependencies on freebsd

    rustup      - update rust
    mach_env    - create mach environment
""")



