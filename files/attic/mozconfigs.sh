create_mozconfig_default() {
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
#export MOZ_REQUIRE_SIGNING=0

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

create_mozconfig_xcompile() {
    cat >../mozconfig <<END
# Crosscompile to windows..

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

create_mozconfig_strict() {
    cat >../mozconfig <<END
# Balls to the wall edition..
ac_add_options --disable-webrtc


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








create_mozconfig_android() {
    cat >../mozconfig <<END
# Original file is from:
# https://raw.githubusercontent.com/Divested-Mobile/Mull/master/MOZCONFIG
#
# Reference
# https://gitweb.torproject.org/user/sysrqb/tor-browser.git/tree/.mozconfig-android
# https://gitlab.com/fdroid/fdroiddata/blob/master/metadata/org.mozilla.fennec_fdroid.txt



# Build for Android
ac_add_options --with-android-min-sdk=16
ac_add_options --enable-application=mobile/android
ac_add_options --target=arm-linux-androideabi
#ac_add_options --target=aarch64-linux-android
#ac_add_options --target=x86_64-linux-android




# Specify paths
ac_add_options --with-android-sdk="/home/emy/.mozbuild/android-sdk-linux"
ac_add_options --with-android-ndk="/home/emy/.mozbuild/android-ndk-r17b"
CC="/home/emy/.mozbuild/clang/bin/clang"
CXX="/home/emy/.mozbuild/clang/bin/clang++"




# Set branding
#ac_add_options --with-branding=mobile/android/branding/divestos


# Build tweaks
ac_add_options --disable-tests


# Disable malware
#ac_add_options --disable-eme
ac_add_options --without-google-play-services

# Disable unneeded extras
ac_add_options --disable-updater
ac_add_options --disable-crashreporter


# Hardening
ac_add_options --enable-hardening

# Optimize
ac_add_options --disable-debug
ac_add_options --disable-profiling
ac_add_options --disable-rust-debug
ac_add_options --enable-optimize
ac_add_options --enable-release
ac_add_options --enable-strip
ac_add_options --enable-rust-simd

export BUILDING_RELEASE=1
export MOZ_DEBUG=
export NIGHTLY_BUILD=


#The following options are the only way to fully disable debugging
export MOZILLA_OFFICIAL=1






#### ORIGINAL MOZCONFIG #####
#ac_add_options --enable-application=browser

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

END
}
