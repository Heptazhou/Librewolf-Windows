#!/usr/bin/python3

#
# pybuild.py - try move functionality away from that too big of a script.
#

import optparse
import sys

parser = optparse.OptionParser()

#parser.add_option('-o', '--output', dest="output_filename", default="default.out")
#parser.add_option('-v', '--verbose',dest="verbose",default=False,action="store_true")
#parser.add_option('--version',dest="version",default=1.0,type="float")
parser.add_option('-x', '--cross',  dest='cross_compile', default=False, action="store_true")
parser.add_option('-s', '--src',    dest='src',           default='release')
parser.add_option('-t', '--distro', dest='distro',        default='win')

options, remainder = parser.parse_args()

#if len(sys.argv[1:])>=1:
#        print('ARGV      :', sys.argv[1:])
#        print('VERSION   :', options.version)
#        print('VERBOSE   :', options.verbose)
#        print('OUTPUT    :', options.output_filename)
#        print('REMAINING :', remainder)
#


for arg in remainder:
        if arg == 'all':
                print("[debug] all")
        elif arg == 'clean':
                print("[debug] clean")
        else:
                print("[debug] unknown command: ", arg)



# Print help message
if len(remainder)<1:
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
        sys.exit(1)
# eof




