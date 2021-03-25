exe=.exe
objdir=obj-x86_64-pc-mingw32/dist/firefox
ospkg=win64

# sanity checks
if [ ! -d $objdir ]; then
    echo "artifacts_win.sh: directory $objdir not found. did you run './build.sh build'?"
    exit 1;
fi

rm -rf ../firefox ../librewolf
cp -r $objdir ..

pushd ..

mv firefox librewolf
# apply the LibreWolf settings
cp -rv settings/* librewolf
# rename the executable manually
pushd librewolf ; mv -v firefox$exe librewolf$exe ; popd
# clean garbage files
cd librewolf ; rm -rf maintenanceservice* pingsender* firefox.*.xml precomplete removed-files ; cd ..
# copy the windows icon
cp -v common/source_files/browser/branding/librewolf/firefox.ico librewolf/librewolf.ico

# create the final zip artifact
rm -f librewolf-$pkgver.en-US.$ospkg.zip
zip -qr9 librewolf-$pkgver.en-US.$ospkg.zip librewolf
if [ $? -ne 0 ]; then exit 1; fi

# now to try to make the installer
rm -f librewolf-$pkgver.en-US.win64-setup.exe tmp.nsi
sed "s/pkg_version/$pkgver/g" < artifacts_win.nsi > tmp.nsi
makensis-3.01.exe -V1 tmp.nsi
if [ $? -ne 0 ]; then exit 1; fi

# patch to experimental config
if [ ! -z $experimental ]; then
    pushd librewolf
    echo "Applying experimental patches..."
    patch -p1 -i ../patches/librewolf-config.patch
    if [ $? -ne 0 ]; then exit 1; fi
    patch -p1 -i ../patches/librewolf-policies.patch
    if [ $? -ne 0 ]; then exit 1; fi
    popd

    # create the final zip artifact
    rm -f librewolf-$pkgver.en-US.$ospkg-experimental.zip
    zip -qr9 librewolf-$pkgver.en-US.$ospkg-experimental.zip librewolf
    if [ $? -ne 0 ]; then exit 1; fi

    # now to try to make the installer
    rm -f librewolf-$pkgver.en-US.win64-experimental-setup.exe tmp-experimental.nsi
    sed "s/win64-setup/win64-experimental-setup/g" < tmp.nsi > tmp-experimental.nsi
    makensis-3.01.exe -V1 tmp-experimental.nsi
    if [ $? -ne 0 ]; then exit 1; fi
fi

popd
