version=$(cat /version)


mkdir -p librewolf/DEBIAN
cd librewolf/DEBIAN

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

# Fill /usr/share/librewolf
mkdir -p usr/share/librewolf
unzip /artifacts/librewolf-*.zip
mv -v librewolf/* usr/share/librewolf
rmdir librewolf

# Symlink
mkdir -p usr/bin
cd usr/bin
ln -s ../share/librewolf/librewolf
cd ../..

# Application icon
mkdir -p usr/share/applications
mkdir -p usr/share/icons
cp -v usr/share/librewolf/browser/chrome/icons/default/default64.png usr/share/icons/librewolf.png
sed "s/MYDIR/\/usr\/share\/librewolf/g" < usr/share/librewolf/start-librewolf.desktop.in > usr/share/applications/librewolf.desktop
# Build .deb file
cd ..
dpkg-deb --build librewolf
cp *.deb artifacts
