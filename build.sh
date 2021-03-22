#!/usr/bin/bash
# build.sh - build librewolf on windows
# derived from https://gitlab.com/librewolf-community/browser/linux/-/blob/master/PKGBUILD

pkgname=librewolf
_pkgname=LibreWolf

pkgver=86.0.1


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

rustup() {
    # rust needs special love: https://www.atechtown.com/install-rust-language-on-debian-10/
    echo "rustup: begin."
    curl https://sh.rustup.rs -sSf | sh
    source $HOME/.cargo/env
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

fetch() {
    echo "fetch: begin."

    # fetch the firefox source.
    rm -f firefox-$pkgver.source.tar.xz
    wget https://archive.mozilla.org/pub/firefox/releases/$pkgver/source/firefox-$pkgver.source.tar.xz
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



do_patches() {
    echo "do_patches: begin."
    
    # get the patches
    echo 'Getting patches..'
    rm -f megabar.patch remove_addons.patch
    wget -q https://gitlab.com/librewolf-community/browser/linux/-/raw/master/megabar.patch
    if [ $? -ne 0 ]; then exit 1; fi
    if [ ! -f megabar.patch ]; then exit 1; fi
    wget -q https://gitlab.com/librewolf-community/browser/linux/-/raw/master/remove_addons.patch
    if [ $? -ne 0 ]; then exit 1; fi
    if [ ! -f remove_addons.patch ]; then exit 1; fi

    if [ ! -d firefox-$pkgver ]; then exit 1; fi
    cd firefox-$pkgver
    
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
# theming bugs: ac_add_options --with-app-name=${pkgname}
# theming bugs: ac_add_options --with-app-basename=${_pkgname}
ac_add_options --with-branding=browser/branding/${pkgname}
ac_add_options --with-distribution-id=io.gitlab.${pkgname}-community
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
	
    echo 'Applying patches...'

    # Apply patches..
    patch -p1 -i ../remove_addons.patch
    if [ $? -ne 0 ]; then exit 1; fi
    patch -p1 -i ../megabar.patch
    if [ $? -ne 0 ]; then exit 1; fi

    # Disabling Pocket
    sed -i "s/'pocket'/#'pocket'/g" browser/components/moz.build
    if [ $? -ne 0 ]; then exit 1; fi
    
    # this one only to remove an annoying error message:
    sed -i 's#SaveToPocket.init();#// SaveToPocket.init();#g' browser/components/BrowserGlue.jsm
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
	mysed='sed'
    fi
    $mysed -z "$_cert_sed" -i toolkit/mozapps/extensions/internal/XPIInstall.jsm
    if [ $? -ne 0 ]; then exit 1; fi


    # allow SearchEngines option in non-ESR builds
    sed -i 's#"enterprise_only": true,#"enterprise_only": false,#g' browser/components/enterprisepolicies/schemas/policies-schema.json
    if [ $? -ne 0 ]; then exit 1; fi

    _settings_services_sed='s#firefox.settings.services.mozilla.com#f.s.s.m.c.qjz9zk#g'
    
    # stop some undesired requests (https://gitlab.com/librewolf-community/browser/common/-/issues/10)
    sed "$_settings_services_sed" -i browser/components/newtab/data/content/activity-stream.bundle.js
    if [ $? -ne 0 ]; then exit 1; fi
    sed "$_settings_services_sed" -i modules/libpref/init/all.js
    if [ $? -ne 0 ]; then exit 1; fi
    sed "$_settings_services_sed" -i services/settings/Utils.jsm
    if [ $? -ne 0 ]; then exit 1; fi
    sed "$_settings_services_sed" -i toolkit/components/search/SearchUtils.jsm
    if [ $? -ne 0 ]; then exit 1; fi
    
    # copy branding resources
    cp -vr ../common/source_files/* ./
    # new branding stuff
    cp -v ../branding_files/configure.sh browser/branding/librewolf
    cp -v ../branding_files/confvars.sh browser/confvars.sh
    
    # just a straight copy for now..
    cp -v ../mozconfig .

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
    
    . ../artifacts_rpm.sh

    cd ..
    echo "artifacts_rpm: done."
}


# windows: change $PATH to find all the build tools in .mozbuild
# this might do the trick on macos aswell?
if [ -f '/c/mozilla-build/start-shell.bat' ]; then
    export TPATH=$HOME/.mozbuild/clang/bin:$HOME/.mozbuild/cbindgen:$HOME/.mozbuild/node:$HOME/.mozbuild/nasm
    export PATH=$TPATH:$PATH
fi

if [ -f $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi

# process commandline arguments and do something

done_something=0

if [[ "$*" == *deps_deb* ]]; then
    deps_deb
    done_something=1
fi
if [[ "$*" == *deps_rpm* ]]; then
    deps_rpm
    done_something=1
fi
if [[ "$*" == *rustup* ]]; then
    rustup
    done_something=1
fi
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
if [[ "$*" == *mach_env* ]]; then
    mach_env
    done_something=1
fi
if [[ "$*" == *build* ]]; then
    build
    done_something=1
fi
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





# by default, give help..
if (( done_something == 0 )); then
    cat <<EOF
Use: ./build.sh  fetch extract do_patches build package artifacts_win

    fetch           - fetch the tarball.
    extract         - extract the tarball.
    do_patches      - create a mozconfig, and patch the source.
    build           - the actual build.
    artifacts_win   - build the .zip and NSIS setup.exe installer.

Linux related functions:

    mach_env        - create mach build environment.
    rustup	    - perform a rustup for this user.
    deps_rpm	    - install dependencies with rpm.
    deps_deb	    - install dependencies with apt.
    artifacts_deb   - create a dist zip file (for debian10).
    artifacts_rpm   - create a dist zip file (for fedora33).

If no parameters are given, it prints this help message.

For debian, use: 
  $ sudo ./build.sh deps_deb 
  $ ./build.sh rustup mach_env fetch extract do_patches build artifacts_deb
EOF
    exit 1
fi
