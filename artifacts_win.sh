# sanity checks
if [ ! -d obj-x86_64-pc-mingw32/dist/firefox ]; then
    echo "artifacts_win.sh: directory obj-x86_64-pc-mingw32/dist/firefox not found."
    exit 1;
fi

rm -rf ../firefox ../librewolf
cp -r obj-x86_64-pc-mingw32/dist/firefox ..


pushd ..
mv firefox librewolf


# apply the LibreWolf settings
cp -rv settings/* librewolf
# rename the executable manually
cd librewolf ; mv -v firefox.exe librewolf.exe ; cd ..
    
# recreate the zip file..

# clean garbage files
cd librewolf ; rm -rf maintenanceservice* pingsender.exe firefox.*.xml precomplete removed-files ; cd ..


# be sure to remove the previous zip file..
rm -f librewolf-$pkgver.en-US.win64.zip*

zip -r9 librewolf-$pkgver.en-US.win64.zip librewolf
if [ $? -ne 0 ]; then exit 1; fi
sha256sum.exe librewolf-$pkgver.en-US.win64.zip > librewolf-$pkgver.en-US.win64.zip.sha256sum
if [ $? -ne 0 ]; then exit 1; fi

# now to try to make the installer.
cp -v common/source_files/browser/branding/librewolf/firefox.ico librewolf/librewolf.ico

sed "s/pkg_version/$pkgver/g" < artifacts_win.nsi > tmp.nsi
makensis-3.01.exe tmp.nsi
if [ $? -ne 0 ]; then exit 1; fi
sha256sum.exe librewolf-$pkgver.en-US.win64-setup.exe > librewolf-$pkgver.en-US.win64-setup.exe.sha256sum
if [ $? -ne 0 ]; then exit 1; fi

popd
