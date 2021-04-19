#!/bin/bash
# build.sh - build librewolf on windows
# derived from https://gitlab.com/librewolf-community/browser/linux/-/blob/master/PKGBUILD
#
# This script is set up like a Makefile, it's a list of functions that perform a
# certain sub-task, that function can be called as a commandline argument to the script.
#

set -e

. ./version.sh

srcdir=firefox-$pkgver

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
    
    echo "Deleting previous firefox-$pkgver ..."
    rm -rf firefox-$pkgver
    
    echo "Extracting firefox-$pkgver.source.tar.xz ..."
    tar xf firefox-$pkgver.source.tar.xz
    if [ $? -ne 0 ]; then exit 1; fi
    if [ ! -d firefox-$pkgver ]; then exit 1; fi
    
    echo "extract: done."
}

. ./mozconfigs.sh

do_patches() {
    echo "do_patches: begin. (srcdir=$srcdir)"

    if [ "$srcdir" == "tor-browser" ]; then
	echo "do_patches: warning: not running do_patches on tor-browser. done."
	return
    fi

    if [ ! -d $srcdir ]; then exit 1; fi
    cd $srcdir

    echo 'Creating mozconfig...'

    if [ "$mozconfig_mode" == "xcompile" ]; then
	create_mozconfig_xcompile
	cp -v ../mozconfig .
    elif [ "$strict" == "strict" ]; then
	create_mozconfig_strict
	cp -v ../mozconfig .
    else
	create_mozconfig_default
	cp -v ../mozconfig .
    fi
    

    echo 'Copy librewolf branding files...'
    
    cp -vr ../common/source_files/* ./
    # new branding stuff
    cp -v ../files/configure.sh browser/branding/librewolf

    echo 'Applying patches...'
    
    patch -p1 -i ../linux/mozilla-vpn-ad.patch
    
    if [ "$srcdir" == "mozilla-unified" ]; then
	echo "../patches/nightly/context-menu2.patch"
	patch -p1 -i ../patches/nightly/context-menu2.patch
	echo "../patches/nightly/report-site-issue.patch"
	patch -p1 -i ../patches/nightly/report-site-issue.patch
	echo "../patches/nightly/megabar2.patch"
	patch -p1 -i ../patches/nightly/megabar2.patch
    else
	echo "../linux/context-menu.patch"
	patch -p1 -i ../linux/context-menu.patch
	echo "../linux/remove_addons.patch"
	patch -p1 -i ../linux/remove_addons.patch
	echo "../linux/megabar.patch"
	patch -p1 -i ../linux/megabar.patch
    fi

    echo 'GNU sed patches...'
    
    echo "../patches/sed-patches/allow-searchengines-non-esr.patch"
    patch -p1 -i ../patches/sed-patches/allow-searchengines-non-esr.patch
    echo "../patches/sed-patches/disable-pocket.patch"
    patch -p1 -i ../patches/sed-patches/disable-pocket.patch
    echo "../patches/sed-patches/remove-internal-plugin-certs.patch"
    patch -p1 -i ../patches/sed-patches/remove-internal-plugin-certs.patch
    echo "../patches/sed-patches/stop-undesired-requests.patch"
    patch -p1 -i ../patches/sed-patches/stop-undesired-requests.patch
    
    echo 'Local patches...'
    
    # local win10 patches
    echo "../patches/browser-confvars.patch"
    patch -p1 -i ../patches/browser-confvars.patch # not sure about this one yet!
    
    if [ "$strict" == "strict" ]; then
	echo 'strict patches...'
    fi
    
    cd ..
    echo "do_patches: done."
}



build() {
    echo "build: begin."
    if [ ! -d $srcdir ]; then exit 1; fi
    cd $srcdir
    
    ./mach build
    if [ $? -ne 0 ]; then exit 1; fi
    
    cd ..
    echo "build: done."
}


. ./artifacts_all.sh

artifacts_win() {
    echo "artifacts_win: begin."
    if [ ! -d $srcdir ]; then exit 1; fi
    cd $srcdir

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
    if [ ! -d $srcdir ]; then exit 1; fi
    cd $srcdir

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
    if [ ! -d $srcdir ]; then exit 1; fi
    cd $srcdir

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
    deps1="python python-dev python3 python3-dev python3-distutils clang pkg-config libpulse-dev gcc"
    deps2="curl wget nodejs libpango1.0-dev nasm yasm zip m4 libgtk-3-dev libgtk2.0-dev libdbus-glib-1-dev"
    deps3="libxt-dev python3-pip mercurial automake autoconf libtool m4"
    apt install -y $deps1
    apt install -y $deps2
    apt install -y $deps3
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

# these utilities should work everywhere
clean() {
    echo "clean: begin."
    
    echo "Deleting firefox-${pkgver} ..."
    rm -rf firefox-$pkgver
    
    echo "Deleting other cruft ..."
    rm -rf librewolf
    rm -f firefox-$pkgver.source.tar.xz
    rm -f mozconfig
    rm -f bootstrap.py
    
    # windows
    rm -f librewolf-$pkgver.en-US.win64.zip
    rm -f librewolf-$pkgver.en-US.win64-setup.exe
    rm -f librewolf-$pkgver.en-US.win64-permissive.zip
    rm -f librewolf-$pkgver.en-US.win64-permissive-setup.exe
    rm -f librewolf-$pkgver.en-US.win64-strict.zip
    rm -f librewolf-$pkgver.en-US.win64-strict-setup.exe
    rm -f tmp.nsi tmp-permissive.nsi tmp-strict.nsi
    
    # linux
    rm -f librewolf-$pkgver.en-US.deb.zip
    rm -f librewolf-$pkgver.en-US.deb-permissive.zip
    rm -f librewolf-$pkgver.en-US.deb-strict.zip
    rm -f librewolf-$pkgver.en-US.rpm.zip
    rm -f librewolf-$pkgver.en-US.rpm-permissive.zip
    rm -f librewolf-$pkgver.en-US.rpm-strict.zip

    echo "clean: done."
}


rustup() {
    # rust needs special love: https://www.atechtown.com/install-rust-language-on-debian-10/
    echo "rustup: begin."
    curl https://sh.rustup.rs -sSf | sh
    . "$HOME/.cargo/env"
    cargo install cbindgen
    echo "rustup: done."
}

mach_env() {
    echo "mach_env: begin."
    if [ ! -d $srcdir ]; then exit 1; fi
    cd $srcdir
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
    if [ ! -d $srcdir ]; then exit 1; fi
    cd $srcdir

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


# Permissive/strict configuration options (win10 only at the moment)

perm_config_diff() {
    pushd settings > /dev/null
      cp "/c/Program Files/LibreWolf/librewolf.cfg" librewolf.cfg
      if [ $? -ne 0 ]; then exit 1; fi
      git diff librewolf.cfg > ../patches/permissive/librewolf-config.patch
      git diff librewolf.cfg
      git checkout librewolf.cfg > /dev/null 2>&1
    popd > /dev/null
}

perm_policies_diff() {
    pushd settings/distribution > /dev/null
      cp "/c/Program Files/LibreWolf/distribution/policies.json" policies.json
      if [ $? -ne 0 ]; then exit 1; fi
      git diff policies.json > ../../patches/permissive/librewolf-policies.patch
      git diff policies.json
      git checkout policies.json > /dev/null 2>&1 
    popd > /dev/null
}

strict_config_diff() {
    pushd settings > /dev/null
      cp "/c/Program Files/LibreWolf/librewolf.cfg" librewolf.cfg
      if [ $? -ne 0 ]; then exit 1; fi
      git diff librewolf.cfg > ../patches/strict/librewolf-config.patch
      git diff librewolf.cfg
      git checkout librewolf.cfg > /dev/null 2>&1
    popd > /dev/null
}

strict_policies_diff() {
    pushd settings/distribution > /dev/null
      cp "/c/Program Files/LibreWolf/distribution/policies.json" policies.json
      if [ $? -ne 0 ]; then exit 1; fi
      git diff policies.json > ../../patches/strict/librewolf-policies.patch
      git diff policies.json
      git checkout policies.json > /dev/null 2>&1 
    popd > /dev/null
}

#
# Nightly builds, alternative builds.
#

init_mozilla_unified() {
    rm -f bootstrap.py
    wget -q https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py
    python3 bootstrap.py
}
set_mozilla_unified() {
    srcdir=mozilla-unified
}
reset_mozilla_unified() {
    echo "reset_mozilla_unified: begin."
    if [ ! -d mozilla-unified ]; then
	echo "Error: mozilla-unified folder not found. use init_mozilla_unified() to create one"
	exit 1;
    fi
    cd mozilla-unified

    echo "Resetting mozilla-unified..."
    hg up -C
    hg purge
    echo "Mercurial pull..."
    hg pull -u
    
    cd ..
    echo "reset_mozilla_unified: done."
}

# tor-browser.. (experimental)
init_tor_browser() {
    git clone --no-checkout https://git.torproject.org/tor-browser.git
    
    cd tor-browser
      git checkout tor-browser-78.8.0esr-10.0-1
      git submodule update --recursive
      patch -p1 -i ../patches/tb-mozconfig-win10.patch 
    cd ..
}
set_tor_browser() {
    srcdir=tor-browser
}
reset_tor_browser() {
    echo "reset_tor_browser: begin."
    if [ ! -d tor-browser ]; then
	echo "Error: tor-browser folder not found. use init_tor_browser() to create one"
	exit 1;
    fi
    cd tor-browser

    echo "Resetting tor-browser..."
    git reset --hard
    
    cd ..
    echo "reset_tor_browser: done."
}



# cross-compile actions...
#
#   linux_patches    - the 'do_patches' for linux->win crosscompile.
#   linux_artifacts  - standard artifact zip file. perhaps a -setup.exe.
#   setup_deb_root   - setup compile environment (root stuff)
#   setup_deb_user   - setup compile environmnet (build user)
#   setup_rpm_root   - setup compile environment (root stuff)
#   setup_rpm_user   - setup compile environmnet (build user)

. ./linux_xcompile.sh




#
# process commandline arguments and do something
#

done_something=0


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

if [[ "$*" == *init_mozilla_unified* ]]; then
    init_mozilla_unified
    done_something=1
fi
if [[ "$*" == *set_mozilla_unified* ]]; then
    set_mozilla_unified
    done_something=1
fi
if [[ "$*" == *reset_mozilla_unified* ]]; then
    reset_mozilla_unified
    done_something=1
fi
if [[ "$*" == *init_tor_browser* ]]; then
    init_tor_browser
    done_something=1
fi
if [[ "$*" == *set_tor_browser* ]]; then
    set_tor_browser
    done_something=1
fi
if [[ "$*" == *reset_tor_browser* ]]; then
    reset_tor_browser
    done_something=1
fi

# permissive & strict modes.
if [[ "$*" == *set_perm* ]]; then
    permissive=permissive
fi
if [[ "$*" == *set_permissive* ]]; then
    permissive=permissive
fi
if [[ "$*" == *set_strict* ]]; then
    strict=strict
fi




if [[ "$*" == *clean* ]]; then
    clean
    done_something=1
fi
if [[ "$*" == *all* ]]; then
    fetch
    extract
    do_patches
    build
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

if [[ "$*" == *artifacts_win* ]]; then
    artifacts_win
    done_something=1
fi
if [[ "$*" == *artifacts_deb* ]]; then
    artifacts_deb
    done_something=1
fi
if [[ "$*" == *artifacts_rpm* ]]; then
    artifacts_rpm
    done_something=1
fi

# librewolf.cfg and policies.json differences

if [[ "$*" == *perm_config_diff* ]]; then
    perm_config_diff
    done_something=1
fi
if [[ "$*" == *perm_policies_diff* ]]; then
    perm_policies_diff
    done_something=1
fi
if [[ "$*" == *strict_config_diff* ]]; then
    strict_config_diff
    done_something=1
fi
if [[ "$*" == *strict_policies_diff* ]]; then
    strict_policies_diff
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

# Basic functionality:

    all                - build all (fetch extract do_patches build artifacts_win)
    clean              - remove generated cruft.

# Linux related functions:

    deps_deb            - install dependencies with apt.
    deps_rpm            - install dependencies with dnf.
    deps_pkg            - install dependencies with pkg.  (experimental)

    artifacts_deb       - apply .cfg, create a dist zip file (for debian10).
    artifacts_rpm       - apply .cfg, create a dist zip file (for fedora33).

# Generic utility functionality:

    mach_env           - create mach build environment.
    rustup             - perform a rustup for this user.
    git_subs           - update git submodules.
    git_init           - create .git folder in firefox-87.0 for creating patches.

# Strict/permissive config:

    set_perm             - produce permissive artifacts.
    set_strict           - produce strict mode build/artifacts

    perm_config_diff     - diff between -release and -permissive config
    perm_policies_diff   - diff between -release and -permissive policies.json
    strict_config_diff   - diff between -release and -strict config
    strict_policies_diff - diff between -release and -strict policies.json

The *_diff commands are dangerous (change repo files), win10 specific, and 
just for internal use. You can use './build set_perm all' to build permissve
and './build set_strict all' for -strict. This functionality exists because
we're constantly balancing settings between usability and security.

# Cross-compile from linux: (experimental)

    linux_patches    - the 'do_patches' for linux->win crosscompile.
    linux_artifacts  - standard artifact zip file. perhaps a -setup.exe.
    setup_deb_root   - setup compile environment (root stuff)
    setup_deb_user   - setup compile environmnet (build user)
    setup_rpm_root   - setup compile environment (root stuff)
    setup_rpm_user   - setup compile environmnet (build user)

# Nightly etc.:

    init_mozilla_unified   - use bootstrap.py to grab the latest mozilla-unified.
    set_mozilla_unified    - use mozilla-unified instead of firefox-87.0 source.
    reset_mozilla_unified  - clean mozilla-unified and pull latest git changes.

You can use init_tor_browser, set_tor_browser as above, but it attempts a Tor
Browser build instead (esr releases). (experimental) or use set_strict to get
a more restricted version (experimental).

# Installation from linux zip file:

Copy the zip file in your $HOME folder, then:

    unzip librewolf-*.zip
    cd librewolf
    ./register-librewolf

That should give an app icon. You can unzip it elsewhere and it will work.

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
