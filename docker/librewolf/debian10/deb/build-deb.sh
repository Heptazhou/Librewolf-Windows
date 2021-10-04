version=$(cat /version)

mkdir -p librewolf/DEBIAN
cd librewolf/DEBIAN

# Depends: libatk1.0-0 (>= 1.12.4), libc6 (>= 2.28), libcairo-gobject2 (>= 1.10.0), libcairo2 (>= 1.10.0), libdbus-1-3 (>= 1.9.14), libdbus-glib-1-2 (>= 0.78), libevent-2.1-6 (>= 2.1.8-stable), libffi6 (>= 3.0.4), libfontconfig1 (>= 2.12.6), libfreetype6 (>= 2.3.5), libgcc1 (>= 1:4.0), libgdk-pixbuf2.0-0 (>= 2.22.0), libglib2.0-0 (>= 2.31.8), libgtk-3-0 (>= 3.0.0), libpango-1.0-0 (>= 1.14.0), libstdc++6 (>= 6), libx11-6, libx11-xcb1, libxcb-shm0, libxcb1, libxcomposite1 (>= 1:0.3-1), libxdamage1 (>= 1:1.1), libxext6, libxfixes3, libxrender1, zlib1g (>= 1:1.2.11.dfsg), fontconfig, procps, debianutils (>= 1.16)
# Recommends: libavcodec58 | libavcodec-extra58 | libavcodec57 | libavcodec-extra57 | libavcodec56 | libavcodec-extra56 | libavcodec55 | libavcodec-extra55 | libavcodec54 | libavcodec-extra54 | libavcodec53 | libavcodec-extra53
# Suggests: fonts-stix | otf-stix, fonts-lmodern, libgssapi-krb5-2 | libkrb53, libcanberra0, libgtk2.0-0, pulseaudio

cat <<EOF > control
Architecture: all
Build-Depends: inkscape, librsvg2-bin
Depends: libc6, libgcc1, libstdc++6, wget
Description: The Librewolf browser.
Download-Size: 56.0 MB
Essential: no
Installed-Size: 204 MB
Maintainer: Bert van der Weerd <bert@stanzabird.nl>
Package: librewolf
Priority: optional
Provides: gnome-www-browser, www-browser, x-www-browser
Section: web
Version: $version
EOF

cd ..

mkdir -p usr/share/librewolf
unzip /artifacts/librewolf-*.zip
mv -v librewolf/* usr/share/librewolf
rmdir librewolf

mkdir -p usr/bin
cd usr/bin
ln -s ../share/librewolf/librewolf
cd ../..

cd ..
dpkg-deb --build librewolf
cp *.deb artifacts
