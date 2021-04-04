#!/bin/bash
# build.sh - build librewolf on windows
# derived from https://gitlab.com/librewolf-community/browser/linux/-/blob/master/PKGBUILD
#
# This script is set up like a Makefile, it's a list of functions that perform a
# certain sub-task, that function can be called as a commandline argument to the script.
#

set -e

pkgver=87.0

#
# Basic functionality
#

fetch() {
    echo "fetch: begin."

    # fetch the firefox source.
    rm -f firefox-$pkgver.source.tar.xz
    echo "Downloading firefox-$pkgver.source.tar.xz ..."
    wget -q https://archive.mozilla.org/pub/firefox/releases/$pkgver/source/firefox-$pkgver.source.tar.xz
    if [ $? -ne 0 ]; then exit 1; fi
    if [ ! -f firefox-$pkgver.source.tar.xz ]; then exit 1; fi
    
    echo "fetch: done."
}



extract() {
    echo "extract: begin."
    
    echo "Deleting previous firefox-${pkgver} ..."
    rm -rf firefox-$pkgver
    
    echo "Extracting firefox-$pkgver.source.tar.xz ..."
    tar xf firefox-$pkgver.source.tar.xz
    if [ $? -ne 0 ]; then exit 1; fi
    if [ ! -d firefox-$pkgver ]; then exit 1; fi
    
    echo "extract: done."
}


# LibreWolf specific mozconfig and patches
create_mozconfig() {
    cat >../mozconfig <<END
ac_add_options --enable-application=browser

# This supposedly speeds up compilation (We test through dogfooding anyway)
ac_add_options --disable-tests
ac_add_options --disable-debug

ac_add_options --enable-release
ac_add_options --enable-hardening
ac_add_options --enable-rust-simd
ac_add_options --enable-optimize


# Branding
ac_add_options --enable-update-channel=release
# theming bugs: ac_add_options --with-app-name=librewolf
# theming bugs: ac_add_options --with-app-basename=LibreWolf
ac_add_options --with-branding=browser/branding/librewolf
ac_add_options --with-distribution-id=io.gitlab.librewolf-community
ac_add_options --with-unsigned-addon-scopes=app,system
ac_add_options --allow-addon-sideload
export MOZ_REQUIRE_SIGNING=0

# Features
ac_add_options --disable-crashreporter
ac_add_options --disable-updater

# Disables crash reporting, telemetry and other data gathering tools
mk_add_options MOZ_CRASHREPORTER=0
mk_add_options MOZ_DATA_REPORTING=0
mk_add_options MOZ_SERVICES_HEALTHREPORT=0
mk_add_options MOZ_TELEMETRY_REPORTING=0

# first attempt to fix the win32 vcredist issue results in build errors..
#WIN32_REDIST_DIR=$VCINSTALLDIR\redist\x86\Microsoft.VC141.CRT
END
}


do_patches() {
    echo "do_patches: begin."

    if [ ! -d firefox-$pkgver ]; then exit 1; fi
    cd firefox-$pkgver

    echo 'Applying patches...'
    
    patch -p1 -i ../linux/context-menu.patch
    if [ $? -ne 0 ]; then exit 1; fi
    patch -p1 -i ../linux/megabar.patch
    if [ $? -ne 0 ]; then exit 1; fi
    patch -p1 -i ../linux/mozilla-vpn-ad.patch
    if [ $? -ne 0 ]; then exit 1; fi
    patch -p1 -i ../linux/remove_addons.patch
    if [ $? -ne 0 ]; then exit 1; fi

    
    echo 'Creating mozconfig...'
    
    create_mozconfig
    # just a straight copy for now..
    cp -v ../mozconfig .

    echo 'GNU sed patches...'
    
    patch -p1 -i ../patches/sed-patches/allow-searchengines-non-esr.patch
    if [ $? -ne 0 ]; then exit 1; fi
    patch -p1 -i ../patches/sed-patches/disable-pocket.patch
    if [ $? -ne 0 ]; then exit 1; fi
    patch -p1 -i ../patches/sed-patches/remove-internal-plugin-certs.patch
    if [ $? -ne 0 ]; then exit 1; fi
    patch -p1 -i ../patches/sed-patches/stop-undesired-requests.patch
    if [ $? -ne 0 ]; then exit 1; fi

    echo 'Copy librewolf branding files...'
    
    # copy branding resources
    cp -vr ../common/source_files/* ./
    # new branding stuff
    cp -v ../files/configure.sh browser/branding/librewolf

    echo 'Local patches...'
    
    # local win10 patches
    patch -p1 -i ../patches/browser-confvars.patch # not sure about this one yet!
    if [ $? -ne 0 ]; then exit 1; fi
    
    cd ..
    echo "do_patches: done."
}



build() {
    echo "build: begin."
    if [ ! -d firefox-$pkgver ]; then exit 1; fi
    cd firefox-$pkgver
    
    ./mach build
    if [ $? -ne 0 ]; then exit 1; fi
    
    cd ..
    echo "build: done."
}


. ./artifacts_all.sh

artifacts_win() {
    echo "artifacts_win: begin."
    if [ ! -d firefox-$pkgver ]; then exit 1; fi
    cd firefox-$pkgver

    ./mach package
    if [ $? -ne 0 ]; then exit 1; fi
    
    echo ""
    echo "artifacts_win: Creating final artifacts."
    echo ""
    
    artifacts_win_details

    cd ..
    echo "artifacts_win: done."
}

artifacts_deb()
{
    echo "artifacts_deb: begin."
    if [ ! -d firefox-$pkgver ]; then exit 1; fi
    cd firefox-$pkgver

    ./mach package
    if [ $? -ne 0 ]; then exit 1; fi
    
    echo ""
    echo "artifacts_deb: Creating final artifacts."
    echo ""
    
    artifacts_deb_details

    cd ..
    echo "artifacts_deb: done."
}


artifacts_rpm()
{
    echo "artifacts_rpm: begin."
    if [ ! -d firefox-$pkgver ]; then exit 1; fi
    cd firefox-$pkgver

    ./mach package
    if [ $? -ne 0 ]; then exit 1; fi
    
    echo ""
    echo "artifacts_rpm: Creating final artifacts."
    echo ""
    
    artifacts_rpm_details

    cd ..
    echo "artifacts_rpm: done."
}



# Dependencies for linux/freebsd.
deps_deb() {
    echo "deps_deb: begin."
    deps="python3 python3-distutils clang pkg-config libpulse-dev gcc curl wget nodejs libpango1.0-dev nasm yasm zip m4 libgtk-3-dev libgtk2.0-dev libdbus-glib-1-dev libxt-dev"
    apt -y install $deps
    echo "deps_deb: done."
}

deps_rpm() {
    echo "deps_rpm: begin."
    deps="python3 python3-distutils-extra clang pkg-config gcc curl wget nodejs nasm yasm zip m4 python3-zstandard python-zstandard python-devel python3-devel gtk3-devel llvm gtk2-devel dbus-glib-devel libXt-devel pulseaudio-libs-devel"
    dnf -y install $deps
    echo "deps_rpm: done."
}

deps_pkg() {
    echo "deps_pkg: begin."
    deps="wget gmake m4 python3 py37-sqlite3 pkgconf llvm node nasm zip unzip yasm"
    pkg install $deps
    echo "deps_pkg: done."
}

deps_mac() {
    echo "deps_mac: begin."
    deps="yasm nasm ffmpeg node@14 gcc dbus nss"
    brew install $deps
    echo "deps_mac: done."
}

# these utilities should work everywhere
clean() {
    echo "clean: begin."
    
    echo "Deleting firefox-${pkgver} ..."
    rm -rf firefox-$pkgver
    
    echo "Deleting other cruft ..."
    rm -rf librewolf
    rm -f firefox-$pkgver.source.tar.xz
    rm -f mozconfig
    
    # windows
    rm -f librewolf-$pkgver.en-US.win64.zip
    rm -f librewolf-$pkgver.en-US.win64-setup.exe
    rm -f librewolf-$pkgver.en-US.win64-permissive.zip
    rm -f librewolf-$pkgver.en-US.win64-permissive-setup.exe
    rm -f tmp.nsi tmp-permissive.nsi
    
    # linux
    rm -f librewolf-$pkgver.en-US.deb.zip
    rm -f librewolf-$pkgver.en-US.deb-permissive.zip
    rm -f librewolf-$pkgver.en-US.rpm.zip
    rm -f librewolf-$pkgver.en-US.rpm-permissive.zip

    echo "clean: done."
}


rustup() {
    # rust needs special love: https://www.atechtown.com/install-rust-language-on-debian-10/
    echo "rustup: begin."
    curl https://sh.rustup.rs -sSf | sh
    . $HOME/.cargo/env
    cargo install cbindgen
    echo "rustup: done."
}

mach_env() {
    echo "mach_env: begin."
    if [ ! -d firefox-$pkgver ]; then exit 1; fi
    cd firefox-$pkgver
    ./mach create-mach-environment
    if [ $? -ne 0 ]; then exit 1; fi
    cd ..
    echo "mach_env: done."    
}

git_subs() {
    echo "git_subs: begin."
    git submodule update --recursive
    git submodule foreach git merge origin master
    echo "git_subs: done."
}

git_init() {
    echo "git_init: begin."
    if [ ! -d firefox-$pkgver ]; then exit 1; fi
    cd firefox-$pkgver

    echo "Removing old .git folder..."
    rm -rf .git

    echo "Creating new .git folder..."
    git init
    git config core.safecrlf false
    git config commit.gpgsign false
    git add -f * .[a-z]*
    git commit -am 'Initial commit'
    
    cd ..
    echo "git_init: done."
}


# Permissive configuration options (win10 only at the moment)

config_diff() {
    pushd settings > /dev/null
      cp "/c/Program Files/LibreWolf/librewolf.cfg" librewolf.cfg
      if [ $? -ne 0 ]; then exit 1; fi
      git diff librewolf.cfg > ../patches/permissive/librewolf-config.patch
      git diff librewolf.cfg
      git checkout librewolf.cfg > /dev/null 2>&1
    popd > /dev/null
}

policies_diff() {
    pushd settings/distribution > /dev/null
      cp "/c/Program Files/LibreWolf/distribution/policies.json" policies.json
      if [ $? -ne 0 ]; then exit 1; fi
      git diff policies.json > ../../patches/permissive/librewolf-policies.patch
      git diff policies.json
      git checkout policies.json > /dev/null 2>&1 
    popd > /dev/null
}



#
# process commandline arguments and do something
#

done_something=0



# cross-compile actions...
#
#   linux_patches    - the 'do_patches' for linux->win crosscompile.
#   linux_artifacts  - standard artifact zip file. perhaps a -setup.exe.
#   setup_deb_root   - setup compile environment (root stuff)
#   setup_deb_user   - setup compile environmnet (build user)
#   setup_rpm_root   - setup compile environment (root stuff)
#   setup_rpm_user   - setup compile environmnet (build user)

. ./linux_xcompile.sh

if [[ "$*" == *linux_patches* ]]; then
    linux_patches
    done_something=1
fi
if [[ "$*" == *linux_artifacts* ]]; then
    linux_artifacts
    done_something=1
fi
if [[ "$*" == *setup_deb_root* ]]; then
    setup_deb_root
    done_something=1
fi
if [[ "$*" == *setup_deb_user* ]]; then
    setup_deb_user
    done_something=1
fi
if [[ "$*" == *setup_rpm_root* ]]; then
    setup_rpm_root
    done_something=1
fi
if [[ "$*" == *setup_rpm_user* ]]; then
    setup_rpm_user
    done_something=1
fi



# various administrative actions...

if [[ "$*" == *clean* ]]; then
    clean
    done_something=1
fi
if [[ "$*" == *all* ]]; then
    fetch
    extract
    do_patches
    build
    permissive=permissive
    artifacts_win
    done_something=1
fi
if [[ "$*" == *git_subs* ]]; then
    git_subs
    done_something=1
fi
if [[ "$*" == *rustup* ]]; then
    rustup
    done_something=1
fi
if [[ "$*" == *mach_env* ]]; then
    mach_env
    done_something=1
fi

# dependencies on various platforms...

if [[ "$*" == *deps_deb* ]]; then
    deps_deb
    done_something=1
fi
if [[ "$*" == *deps_rpm* ]]; then
    deps_rpm
    done_something=1
fi
if [[ "$*" == *deps_pkg* ]]; then
    deps_pkg
    done_something=1
fi
if [[ "$*" == *deps_mac* ]]; then
    deps_mac
    done_something=1
fi

# main building actions...

if [[ "$*" == *fetch* ]]; then
    fetch
    done_something=1
fi
if [[ "$*" == *extract* ]]; then
    extract
    done_something=1
fi
if [[ "$*" == *do_patches* ]]; then
    do_patches
    done_something=1
fi
if [[ "$*" == *git_init* ]]; then
    git_init
    done_something=1
fi
if [[ "$*" == *build* ]]; then
    build
    done_something=1
fi

# creating the artifacts...

if [[ "$*" == *artifacts_perm* ]]; then
    permissive=permissive
    artifacts_win
    done_something=1
else
    if [[ "$*" == *artifacts_win* ]]; then
	artifacts_win
	done_something=1
    fi
fi
if [[ "$*" == *artifacts_deb_perm* ]]; then
    permissive=permissive
    artifacts_deb
    done_something=1
else
    if [[ "$*" == *artifacts_deb* ]]; then
	artifacts_deb
	done_something=1
    fi
fi
if [[ "$*" == *artifacts_rpm_perm* ]]; then
    permissive=permissive
    artifacts_rpm
    done_something=1
else
    if [[ "$*" == *artifacts_rpm* ]]; then
	artifacts_rpm
	done_something=1
    fi
fi

# librewolf.cfg and policies.json differences

if [[ "$*" == *config_diff* ]]; then
    config_diff
    done_something=1
fi
if [[ "$*" == *policies_diff* ]]; then
    policies_diff
    done_something=1
fi
if [[ "$*" == *mach_run_config* ]]; then
    cp -r settings/* $(echo firefox-$pkgver/obj-*)/dist/bin
    done_something=1
fi



# by default, give help..
if (( done_something == 0 )); then
    cat << EOF
Use: ./build.sh clean | all | [other stuff...]

    fetch            - fetch the tarball.
    extract          - extract the tarball.
    do_patches       - create a mozconfig, and patch the source.
    build            - the actual build.

    artifacts_win    - apply .cfg, build the zip file and NSIS setup.exe installer.
    artifacts_perm   - package as above, but use the permissive config/policies.

# Linux related functions:

    deps_deb	        - install dependencies with apt.
    deps_rpm	        - install dependencies with dnf.
    deps_pkg	        - install dependencies with pkg. (freebsd)
    deps_mac	        - install dependencies with brew. (macOS)

    artifacts_deb       - apply .cfg, create a dist zip file (for debian10).
    artifacts_deb_perm  - include permissive build.
    artifacts_rpm       - apply .cfg, create a dist zip file (for fedora33).
    artifacts_rpm_perm  - include permissive build.

# Generic utility functionality:

    all             - build all, produce all artifacts including -permissive.
    clean           - remove generated cruft.

    mach_env        - create mach build environment.
    rustup	    - perform a rustup for this user.
    git_subs        - update git submodules.
    config_diff     - diff between my .cfg and dist .cfg file. (win10)
    policies_diff   - diff between my policies and the dist policies. (win10)
    git_init        - create .git folder in firefox-$pkgver for creating patches.
    mach_run_config - copy librewolf config/policies to enable 'mach run'.

# Cross-compile from linux:

   linux_patches    - the 'do_patches' for linux->win crosscompile.
   linux_artifacts  - standard artifact zip file. perhaps a -setup.exe.
   setup_deb_root   - setup compile environment (root stuff)
   setup_deb_user   - setup compile environmnet (build user)
   setup_rpm_root   - setup compile environment (root stuff)
   setup_rpm_user   - setup compile environmnet (build user)
   
Documentation is in the build-howto.md. In a docker situation, we'd like
to run something like: 

  ./build.sh fetch extract linux_patches build linux_artifacts

# Installation from linux zip file:

Copy the zip file in your \$HOME folder, then:
``
unzip librewolf-*.zip
cd librewolf
./register-librewolf
``
That should give an app icon. You can have it elsewhere and it will work.

# Examples:
  
    For windows, use:
      ./build.sh fetch extract do_patches build artifacts_win
      ./build.sh all

    For debian, use: 
      sudo ./build.sh deps_deb 
      ./build.sh rustup mach_env
      ./build.sh fetch extract do_patches build artifacts_deb

EOF
    exit 1
fi
