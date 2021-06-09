#!/bin/env python3

pkgver='89.0'

#
# pybuild.py - try move functionality away from that too big/horrible build script.
#

import optparse
import sys
import os

parser = optparse.OptionParser()

parser.add_option('-x', '--cross',         dest='cross_compile', default=False, action="store_true")
parser.add_option('-n', '--no-execute',    dest='no_execute',    default=False, action="store_true")
parser.add_option('-l', '--no-librewolf',  dest='no_librewolf',  default=False, action="store_true")
parser.add_option('-s', '--src',           dest='src',           default='release')
parser.add_option('-t', '--distro',        dest='distro',        default='win')

options, remainder = parser.parse_args()

                
#print("[debug] ----------")
#print("[debug] --cross  = ", options.cross_compile)
#print("[debug] --no-execute = ", options.no_execute)
#print("[debug] --src    = ", options.src)
#print("[debug] --distro = ", options.distro)
#print("[debug] ----------")




def beep():
        print('\a')


def enter_srcdir():
        dir = "firefox-{}".format(pkgver)
        if options.src == 'nightly':
                dir = 'mozilla-unified'
        elif options.src == 'tor-browser':
                dir = 'tor-browser'
        print("cd {}".format(dir))
        if not options.no_execute:
                os.chdir(dir)
                
def leave_srcdir():
        print("cd ..")
        if not options.no_execute:
                os.chdir("..")
        
def exec(cmd):
        print("{}".format(cmd))
        if not options.no_execute:
                retval = os.system(cmd)
                if retval != 0:
                        beep()
                        sys.exit(1)




        
# Utilities:
def execute_git_subs():
        exec("git submodule update --recursive")
        exec("git submodule foreach git pull origin master")
        exec("git submodule foreach git merge origin master")

def execute_git_init():
        enter_srcdir()
        exec("rm -rf .git")
        exec("git init")
        exec("git config core.safecrlf false")
        exec("git config commit.gpgsign false")
        exec("git add -f * .[a-z]*")
        exec("git commit -am 'Initial commit'")
        leave_srcdir()
        
        
def execute_deps_deb():
        deps1 = "python python-dev python3 python3-dev python3-distutils clang pkg-config libpulse-dev gcc"
        deps2 = "curl wget nodejs libpango1.0-dev nasm yasm zip m4 libgtk-3-dev libgtk2.0-dev libdbus-glib-1-dev"
        deps3 = "libxt-dev python3-pip mercurial automake autoconf libtool m4"
        exec("apt install -y {} {} {}".format(deps1,deps2,deps3))
        
def execute_deps_rpm():
        deps1 = "python3 python3-distutils-extra clang pkg-config gcc curl wget nodejs nasm yasm zip m4"
        deps2 = "python3-zstandard python-zstandard python-devel python3-devel gtk3-devel llvm gtk2-devel dbus-glib-devel libXt-devel pulseaudio-libs-devel"
        exec("dnf -y install {} {}".format(deps1,deps2))
        
def execute_deps_pkg():
        deps = "wget gmake m4 python3 py37-sqlite3 pkgconf llvm node nasm zip unzip yasm"
        exec("pkg install {}".format(deps))

        
def execute_rustup():        
        # rust needs special love: https://www.atechtown.com/install-rust-language-on-debian-10/
        exec("curl https://sh.rustup.rs -sSf | sh")
        exec("cargo install cbindgen")
        
def execute_mach_env():
        enter_srcdir()
        exec("bash ./mach create-mach-environment")
        leave_srcdir()
        
                        


        




# Targets:
def execute_fetch():
        if options.src == 'release':
                exec("rm -f firefox-{}.source.tar.xz".format(pkgver))
                exec("wget -q https://archive.mozilla.org/pub/firefox/releases/{}/source/firefox-{}.source.tar.xz".format(pkgver, pkgver))
        elif options.src == 'nightly':
                exec("rm -f bootstrap.py")
                exec("rm -rf mozilla-unified")
                exec("wget -q https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py")
                exec("python3 bootstrap.py --no-interactive --application-choice=browser")
        elif options.src == 'tor-browser':
                exec("rm -rf tor-browser")
                exec("git clone --no-checkout --recursive https://git.torproject.org/tor-browser.git")
                enter_srcdir()
                exec("git checkout tor-browser-89.0-10.5-1-build1")
                exec("git submodule update --recursive")
                exec("patch -p1 -i ../patches/tb-mozconfig-win10.patch")
                leave_srcdir()

def execute_extract():
        if options.src == 'release':
                exec("rm -rf firefox-{}".format(pkgver))
                exec("tar xf firefox-{}.source.tar.xz".format(pkgver))
        
def execute_lw_do_patches():
        if options.no_librewolf:
                return
        print("[debug] doing target -> lw_do_patches")
        
def execute_build():
        enter_srcdir()
        exec("bash ./mach build")
        leave_srcdir()
        
def execute_lw_post_build():
        if options.no_librewolf:
                return
        print("[debug] doing target -> lw_post_build")
        
def execute_package():
        enter_srcdir()
        exec("bash ./mach package")
        leave_srcdir()

def execute_lw_artifacts():
        if options.no_librewolf:
                return
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
        if options.src == 'release':
                exec("rm -rf firefox-{}".format(pkgver))
        elif options.src == 'nightly':
                exec("rm -rf mozilla-unified")
        elif options.src == 'tor-browser': 
                exec("rm -rf tor-browser")
        
        exec("rm -rf librewolf firefox-{}.source.tar.xz mozconfig bootstrap.py".format(pkgver))
        exec("rm -f librewolf-{}.en-US.win64.zip librewolf-{}.en-US.win64-setup.exe".format(pkgver,pkgver))
        exec("rm -f tmp.nsi tmp-permissive.nsi tmp-strict.nsi".format())





        



#
# main commandline interface
#

if options.src == 'tor-browser':
        options.no_librewolf = True

if len(remainder) > 0:
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
        beep()
else:
        # Print help message
        print("""# Use: 

     pybuild [<options>] clean | all | <targets>

# Options:

    -n,--no-execute         - print commands, don't execute them
    -l,--no-librewolf       - skip LibreWolf specific stages.
    -x,--cross              - crosscompile from linux, implies -t win
    -s,--src <src>          - release,nightly,tor-browser
                              (default=release)
    -t,--distro <distro>    - deb,rpm,win (default=win)

# Targets:

    all      - all steps from fetch to producing setup.exe
    clean    - clean everything, including extracted/fetched sources

    fetch               - wget or hg clone or git pull
    extract             - nop if not wget
    lw_do_patches       - [librewolf] patch the source
    build               - build the browser
    lw_post_build       - [librewolf] insert our settings
    package             - package the browser into zip/apk
    lw_artifacts        - [librewolf] build setup.exe

# Utilities:

    git_subs    - git update submodules
    git_init    - put the source folder in a .git repository

    deps_deb    - install dependencies with apt
    deps_rpm    - install dependencies with dnf
    deps_pkg    - install dependencies on freebsd

    rustup      - update rust
    mach_env    - create mach environment
""")



