# build.sh - build librewolf on windows
# derived from https://gitlab.com/librewolf-community/browser/linux/-/blob/master/PKGBUILD

pkgname=librewolf
_pkgname=LibreWolf

pkgver=85.0.1



fetch() {
    rm -f firefox-$pkgver.source.tar.xz
    wget https://archive.mozilla.org/pub/firefox/releases/$pkgver/source/firefox-$pkgver.source.tar.xz
    
    # the settings and common submodules should be checked out to allow the build

    rm -f megabar.patch remove_addons.patch unity-menubar.patch
    wget https://gitlab.com/librewolf-community/browser/linux/-/raw/master/megabar.patch
    wget https://gitlab.com/librewolf-community/browser/linux/-/raw/master/remove_addons.patch
    wget https://gitlab.com/librewolf-community/browser/linux/-/raw/master/unity-menubar.patch
}



prepare() {
    rm -rf firefox-$pkgver
    tar xf firefox-$pkgver.source.tar.xz

    cd firefox-$pkgver
    
    cat >../mozconfig <<END
ac_add_options --enable-application=browser

# This supposedly speeds up compilation (We test through dogfooding anyway)
ac_add_options --disable-tests
ac_add_options --disable-debug

ac_add_options --enable-release
ac_add_options --enable-hardening
ac_add_options --enable-rust-simd


# as suggested by Mental Outlaw in https://www.youtube.com/watch?v=L2otiFy4ADI
ac_add_options --disable-webrtc


# Branding
ac_add_options --enable-update-channel=release
ac_add_options --with-app-name=${pkgname}
ac_add_options --with-app-basename=${_pkgname}
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
END



    patch -p1 -i ../remove_addons.patch
    patch -p1 -i ../megabar.patch
    patch -p1 -i ../unity-menubar.patch



    # Disabling Pocket
    sed -i "s/'pocket'/#'pocket'/g" browser/components/moz.build
    # this one only to remove an annoying error message:
    sed -i 's#SaveToPocket.init();#// SaveToPocket.init();#g' browser/components/BrowserGlue.jsm



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
	$mysed='sed'
    fi
    $mysed -z "$_cert_sed" -i toolkit/mozapps/extensions/internal/XPIInstall.jsm



    # allow SearchEngines option in non-ESR builds
    sed -i 's#"enterprise_only": true,#"enterprise_only": false,#g' browser/components/enterprisepolicies/schemas/policies-schema.json

    _settings_services_sed='s#firefox.settings.services.mozilla.com#f.s.s.m.c.qjz9zk#g'

    # stop some undesired requests (https://gitlab.com/librewolf-community/browser/common/-/issues/10)
    sed "$_settings_services_sed" -i browser/components/newtab/data/content/activity-stream.bundle.js
    sed "$_settings_services_sed" -i modules/libpref/init/all.js
    sed "$_settings_services_sed" -i services/settings/Utils.jsm
    sed "$_settings_services_sed" -i toolkit/components/search/SearchUtils.jsm



    cp -r ../common/source_files/* ./

    # FIXME: this 'mozconfig' file in the 'common' submodule should be removed
    # this submodule is purely for the branding.
    rm -f mozconfig

    # FIXME: on windows: the stubinstaller folder is missing from the librewolf branding folder.
    # this might be a bug in FF however as it seems to take missing branding resources from
    # the nightly branding. We probably want this stuff merged into the 'common' submodule.
    cp -r ../missing_branding_files/* browser/branding/librewolf

    # just a straight copy for now..
    cp ../mozconfig .mozconfig

    cd ..
}



build() {
    cd firefox-$pkgver

    ./mach build

    cd ..
}



package() {
    cd firefox-$pkgver

    ./mach package

    cd ..
}

installer_win() {
    cd firefox-$pkgver

    # there is just too much garbage in this installer function to
    # have it all here..
    . ../installer_win.sh

    cd ..
}



# windows: change $PATH to find all the build tools in .mozbuild
# this might do the trick on macos aswell?
if [ -f '/c/mozilla-build/start-shell.bat' ]; then
    export TPATH=$HOME/.mozbuild/clang/bin:$HOME/.mozbuild/cbindgen:$HOME/.mozbuild/node:$HOME/.mozbuild/nasm
    export PATH=$TPATH:$PATH
fi



# process commandline arguments and do something
done_something=0
if [[ "$*" == *fetch* ]]; then
    fetch
    done_something=1
fi
if [[ "$*" == *prepare* ]]; then
    prepare
    done_something=1
fi
if [[ "$*" == *build* ]]; then
    build
    done_something=1
fi
if [[ "$*" == *package* ]]; then
    package
    done_something=1
fi
if [[ "$*" == *installer_win* ]]; then
    installer_win
    done_something=1
fi

# by default, do the whole thing..
if (( done_something == 0 )); then
    fetch
    prepare
    build
    package
    installer_win
fi
