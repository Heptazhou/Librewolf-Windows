#!/bin/bash
# build.sh - build librewolf on windows
# derived from https://gitlab.com/librewolf-community/browser/linux/-/blob/master/PKGBUILD
#
# This script is set up like a Makefile, it's a list of functions that perform a
# certain sub-task, that function can be called as a commandline argument to the script.
#

set -e

pkgver=87.0


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
    deps="wget gsed gmake m4 python3 py37-sqlite3 pkgconf llvm node nasm zip unzip yasm"
    pkg install $deps
    echo "deps_pkg: done."
}

clean() {
    echo "clean: begin."
    
    echo "Deleting firefox-${pkgver} ..."
    rm -rf firefox-$pkgver
    
    echo "Deleting other cruft ..."
    rm -rf librewolf
    rm -f firefox-$pkgver.source.tar.xz
    rm -f mozconfig
    rm -f *.patch
    
    # windows
    rm -f librewolf-$pkgver.en-US.win64.zip
    rm -f librewolf-$pkgver.en-US.win64-setup.exe
    rm -f librewolf-$pkgver.en-US.win64-experimental.zip
    rm -f librewolf-$pkgver.en-US.win64-experimental-setup.exe
    rm -f tmp.nsi tmp-experimental.nsi
    
    # linux
    rm -f librewolf-$pkgver.en-US.deb.zip
    rm -f librewolf-$pkgver.en-US.deb-experimental.zip
    rm -f librewolf-$pkgver.en-US.rpm.zip

    echo "clean: done."
}


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
    
    # get the patches
    echo 'Getting patches...'
    rm -f context-menu.patch megabar.patch mozilla-vpn-ad.patch remove_addons.patch unity-menubar.patch
    
    wget -q https://gitlab.com/librewolf-community/browser/linux/-/raw/master/context-menu.patch
    if [ $? -ne 0 ]; then exit 1; fi
    if [ ! -f context-menu.patch ]; then exit 1; fi
    wget -q https://gitlab.com/librewolf-community/browser/linux/-/raw/master/megabar.patch
    if [ $? -ne 0 ]; then exit 1; fi
    if [ ! -f megabar.patch ]; then exit 1; fi
    wget -q https://gitlab.com/librewolf-community/browser/linux/-/raw/master/mozilla-vpn-ad.patch
    if [ $? -ne 0 ]; then exit 1; fi
    if [ ! -f mozilla-vpn-ad.patch ]; then exit 1; fi
    wget -q https://gitlab.com/librewolf-community/browser/linux/-/raw/master/remove_addons.patch
    if [ $? -ne 0 ]; then exit 1; fi
    if [ ! -f remove_addons.patch ]; then exit 1; fi
    

    if [ ! -d firefox-$pkgver ]; then exit 1; fi
    cd firefox-$pkgver

	
    echo 'Applying patches...'

    # Apply patches..
    # context-menu.patch megabar.patch mozilla-vpn-ad.patch remove_addons.patch unity-menubar.patch
    echo 'context-menu.patch:'
    patch -p1 -i ../context-menu.patch
    if [ $? -ne 0 ]; then exit 1; fi
    echo 'megabar.patch:'
    patch -p1 -i ../megabar.patch
    if [ $? -ne 0 ]; then exit 1; fi
    echo 'mozilla-vpn-ad.patch:'
    patch -p1 -i ../mozilla-vpn-ad.patch
    if [ $? -ne 0 ]; then exit 1; fi
    echo 'remove_addons.patch:'
    patch -p1 -i ../remove_addons.patch
    if [ $? -ne 0 ]; then exit 1; fi

    
    # create mozconfig..    
    create_mozconfig
    # just a straight copy for now..
    cp -v ../mozconfig .

    
    # on freebsd we're called gsed..
    set +e
    sed=sed
    gsed --version > /dev/null
    if [ $? -eq 0 ]; then
	sed=gsed;
	# disable webrtc, build errors
    cat>>../mozconfig <<END
# disable webrtc on freebsd
ac_add_options --disable-webrtc
END
    fi
    set -e

    
    # Disabling Pocket
    $sed -i "s/'pocket'/#'pocket'/g" browser/components/moz.build
    if [ $? -ne 0 ]; then exit 1; fi
    
    # this one only to remove an annoying error message:
    $sed -i 's#SaveToPocket.init();#// SaveToPocket.init();#g' browser/components/BrowserGlue.jsm
    if [ $? -ne 0 ]; then exit 1; fi
	
    # Remove Internal Plugin Certificates
    _cert_sed='s#if (aCert.organizationalUnit == "Mozilla [[:alpha:]]\+") {\n'
    _cert_sed+='[[:blank:]]\+return AddonManager\.SIGNEDSTATE_[[:upper:]]\+;\n'
    _cert_sed+='[[:blank:]]\+}#'
    _cert_sed+='// NOTE: removed#g'
    # on windows: the sed.exe in MozBuild is too old, no -z, using the one from Git instead.
    if [ -f '/c/mozilla-build/start-shell.bat' ]; then
	mysed='/c/mozilla-source/Git/usr/bin/sed.exe'
	if [ ! -f $mysed ]; then
	    echo 'build.sh: For the build to work, copy "c:\program files\Git" folder into "c:\mozilla-source".'
	    exit
	fi
    else
	mysed=$sed
    fi
    $mysed -z "$_cert_sed" -i toolkit/mozapps/extensions/internal/XPIInstall.jsm
    if [ $? -ne 0 ]; then exit 1; fi


    # allow SearchEngines option in non-ESR builds
    $sed -i 's#"enterprise_only": true,#"enterprise_only": false,#g' browser/components/enterprisepolicies/schemas/policies-schema.json
    if [ $? -ne 0 ]; then exit 1; fi

    _settings_services_sed='s#firefox.settings.services.mozilla.com#f.s.s.m.c.qjz9zk#g'
    
    # stop some undesired requests (https://gitlab.com/librewolf-community/browser/common/-/issues/10)
    $sed "$_settings_services_sed" -i browser/components/newtab/data/content/activity-stream.bundle.js
    if [ $? -ne 0 ]; then exit 1; fi
    $sed "$_settings_services_sed" -i modules/libpref/init/all.js
    if [ $? -ne 0 ]; then exit 1; fi
    $sed "$_settings_services_sed" -i services/settings/Utils.jsm
    if [ $? -ne 0 ]; then exit 1; fi
    $sed "$_settings_services_sed" -i toolkit/components/search/SearchUtils.jsm
    if [ $? -ne 0 ]; then exit 1; fi
    
    # copy branding resources
    cp -vr ../common/source_files/* ./
    # new branding stuff
    cp -v ../branding_files/configure.sh browser/branding/librewolf

    # local patches
    echo 'Local patches...'
    
    echo 'browser-confvars.patch:'
    patch -p1 -i ../patches/browser-confvars.patch
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




artifacts_win() {
    echo "artifacts_win: begin."
    if [ ! -d firefox-$pkgver ]; then exit 1; fi
    cd firefox-$pkgver

    ./mach package
    if [ $? -ne 0 ]; then exit 1; fi
    
    echo ""
    echo "artifacts_win: Creating final artifacts."
    echo ""
    
    # there is just too much garbage in this installer function to
    # have it all here..
    . ../artifacts_win.sh

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
    
    . ../artifacts_deb.sh

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
    
    . ../artifacts_rpm.sh

    cd ..
    echo "artifacts_rpm: done."
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

#
# Experimental configuration options
#

config_diff() {
    pushd settings > /dev/null
      cp "/c/Program Files/LibreWolf/librewolf.cfg" librewolf.cfg
      git diff librewolf.cfg > ../patches/librewolf-config.patch
      git diff librewolf.cfg
      git checkout librewolf.cfg > /dev/null 2>&1
    popd > /dev/null
}

policies_diff() {
    pushd settings/distribution > /dev/null
      cp "/c/Program Files/LibreWolf/distribution/policies.json" policies.json
      git diff policies.json > ../../patches/librewolf-policies.patch
      git diff policies.json
      git checkout policies.json > /dev/null 2>&1 
    popd > /dev/null
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






# windows: change $PATH to find all the build tools in .mozbuild
# this might do the trick on macos aswell?
if [ -f '/c/mozilla-build/start-shell.bat' ]; then
    export TPATH=$HOME/.mozbuild/clang/bin:$HOME/.mozbuild/cbindgen:$HOME/.mozbuild/node:$HOME/.mozbuild/nasm
    export PATH=$TPATH:$PATH
fi

if [ -f $HOME/.cargo/env ]; then
    . $HOME/.cargo/env
fi






# process commandline arguments and do something

done_something=0

# various administrative actions...

if [[ "$*" == *clean* ]]; then
    clean
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

if [[ "$*" == *artifacts_exp* ]]; then
    experimental=experimental
    artifacts_exp
    done_something=1
else
    if [[ "$*" == *artifacts_win* ]]; then
	artifacts_win
	done_something=1
    fi
fi
if [[ "$*" == *artifacts_deb_exp* ]]; then
    experimental=experimental
    artifacts_deb
    done_something=1
else
    if [[ "$*" == *artifacts_deb* ]]; then
	artifacts_deb
	done_something=1
    fi
fi
if [[ "$*" == *artifacts_rpm_exp* ]]; then
    experimental=experimental
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
Use: ./build.sh  fetch extract do_patches build artifacts_win

    fetch           - fetch the tarball.
    extract         - extract the tarball.
    do_patches      - create a mozconfig, and patch the source.
    build           - the actual build.
    artifacts_win   - apply .cfg, build the zip file and NSIS setup.exe installer.
    artifacts_exp   - package as above, but use the experimental config/policies.

Linux related functions:

    deps_deb	       - install dependencies with apt.
    deps_rpm	       - install dependencies with dnf.
    deps_pkg	       - install dependencies with pkg.
    artifacts_deb      - apply .cfg, create a dist zip file (for debian10).
    artifacts_deb_exp  - include experimental build.
    artifacts_rpm      - apply .cfg, create a dist zip file (for fedora33).
    artifacts_rpm_exp  - include experimental build.

Generic utility functionality:

    mach_env        - create mach build environment.
    rustup	    - perform a rustup for this user.

    clean           - remove generated cruft.
    git_subs        - update git submodules.
    config_diff     - diff between my .cfg and dist .cfg file. (win10)
    policies_diff   - diff between my policies and the dist policies. (win10)
    git_init        - create .git folder in firefox-$pkgver for creating patches.
    mach_run_config - copy librewolf config/policies to enable 'mach run'.

Examples:
  
    For windows, use:
      ./build.sh fetch extract do_patches build artifacts_win

    For debian, use: 
      sudo ./build.sh deps_deb 
      ./build.sh rustup mach_env
      ./build.sh fetch extract do_patches build artifacts_deb

EOF
    exit 1
fi
