# apply the LibreWolf settings
cp -rv ../settings/* obj-x86_64-pc-mingw32/dist/librewolf
    
# recreate the zip file..
cd obj-x86_64-pc-mingw32/dist
rm -f librewolf-$pkgver.en-US.win64.txt librewolf-$pkgver.en-US.win64.zip
zip -r9 librewolf-$pkgver.en-US.win64.zip librewolf
/c/mozilla-source/Git/usr/bin/sha256sum.exe librewolf-$pkgver.en-US.win64.zip > librewolf-$pkgver.en-US.win64.zip.sha256sum
rm -f ../../../librewolf-$pkgver.en-US.win64.zip*
cp librewolf-$pkgver.en-US.win64.zip* ../../..
cd ../..
