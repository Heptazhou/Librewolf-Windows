Name:           librewolf
Version:        __VERSION__
Release:        1%{?dist}
BuildArch:      x86_64
Summary:        The LibreWolf browser
License:        MPL
URL:            https://librewolf-community.gitlab.io/
Source0:        lw.tar.gz
#BuildRequires:  
#Requires:       
%description
The LibreWolf browser for privacy, with uBlock and tweaked settings.

%prep
%setup -q

%install
mkdir -p "$RPM_BUILD_ROOT"
cp -rv * "$RPM_BUILD_ROOT"

%files
/usr/share/librewolf/application.ini
/usr/share/librewolf/browser/chrome/icons/default/default128.png
/usr/share/librewolf/browser/chrome/icons/default/default16.png
/usr/share/librewolf/browser/chrome/icons/default/default32.png
/usr/share/librewolf/browser/chrome/icons/default/default48.png
/usr/share/librewolf/browser/chrome/icons/default/default64.png
/usr/share/librewolf/browser/features/formautofill@mozilla.org.xpi
/usr/share/librewolf/browser/features/pictureinpicture@mozilla.org.xpi
/usr/share/librewolf/browser/features/screenshots@mozilla.org.xpi
/usr/share/librewolf/browser/omni.ja
/usr/share/librewolf/defaults/pref/channel-prefs.js
/usr/share/librewolf/dependentlibs.list
/usr/share/librewolf/distribution/policies.json
/usr/share/librewolf/fonts/TwemojiMozilla.ttf
/usr/share/librewolf/gmp-clearkey/0.1/libclearkey.so
/usr/share/librewolf/gmp-clearkey/0.1/manifest.json
/usr/share/librewolf/libfreeblpriv3.so
/usr/share/librewolf/liblgpllibs.so
/usr/share/librewolf/libmozavcodec.so
/usr/share/librewolf/libmozavutil.so
/usr/share/librewolf/libmozgtk.so
/usr/share/librewolf/libmozsandbox.so
/usr/share/librewolf/libmozsqlite3.so
/usr/share/librewolf/libmozwayland.so
/usr/share/librewolf/libnspr4.so
/usr/share/librewolf/libnss3.so
/usr/share/librewolf/libnssckbi.so
/usr/share/librewolf/libnssutil3.so
/usr/share/librewolf/libplc4.so
/usr/share/librewolf/libplds4.so
/usr/share/librewolf/librewolf
/usr/share/librewolf/librewolf-bin
/usr/share/librewolf/librewolf.cfg
/usr/share/librewolf/librewolf.ico
/usr/share/librewolf/libsmime3.so
/usr/share/librewolf/libsoftokn3.so
/usr/share/librewolf/libssl3.so
/usr/share/librewolf/libxul.so
/usr/share/librewolf/omni.ja
/usr/share/librewolf/platform.ini
/usr/share/librewolf/plugin-container
/usr/share/librewolf/register-librewolf
/usr/share/librewolf/start-librewolf
/usr/share/librewolf/start-librewolf.desktop.in
/usr/bin/librewolf
/usr/share/applications/librewolf.desktop
/usr/share/icons/librewolf.png
