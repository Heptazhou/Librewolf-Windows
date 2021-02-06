# apply the LibreWolf settings
cp -rv ../settings/* obj-x86_64-pc-mingw32/dist/librewolf
    
# recreate the zip file..
cd obj-x86_64-pc-mingw32/dist
 # clean garbage files
 rm -vrf librewolf/uninstall librewolf/maintenanceservice* librewolf/pingsender.exe
 # be sure to remove the previous zip file..
 rm -vf librewolf-$pkgver.en-US.win64.txt librewolf-$pkgver.en-US.win64.zip
 zip -r9 librewolf-$pkgver.en-US.win64.zip librewolf
 /c/mozilla-source/Git/usr/bin/sha256sum.exe librewolf-$pkgver.en-US.win64.zip > librewolf-$pkgver.en-US.win64.zip.sha256sum
 # copy the resulting zip file
 rm -vf ../../../librewolf-$pkgver.en-US.win64.zip*
 cp -v librewolf-$pkgver.en-US.win64.zip* ../../..
cd ../..

# now to try to make the installer
pushd ..
 rm -vrf librewolf
 unzip librewolf-$pkgver.en-US.win64.zip
 cp -v missing_branding_files/firefox.ico librewolf/librewolf.ico
 makensis-3.01.exe librewolf.nsi
 /c/mozilla-source/Git/usr/bin/sha256sum.exe librewolf-$pkgver.en-US.win64-setup.exe > librewolf-$pkgver.en-US.win64-setup.exe.sha256sum
popd
