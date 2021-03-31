exe=
objdir=obj-x86_64-pc-linux-gnu/dist/firefox
ospkg=deb

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

# linux: copy app icon stuff
cp branding_files/register-librewolf branding_files/start-librewolf branding_files/start-librewolf.desktop.in librewolf

# create the final zip artifact
rm -f librewolf-$pkgver.en-US.$ospkg.zip
zip -qr9 librewolf-$pkgver.en-US.$ospkg.zip librewolf
if [ $? -ne 0 ]; then exit 1; fi

# now to try to make the installer
# (create a .deb here)

# patch to permissive config
if [ ! -z $permissive ]; then
    pushd librewolf
    echo "Applying permissive patches..."
    patch -p1 -i ../patches/permissive/librewolf-config.patch
    if [ $? -ne 0 ]; then exit 1; fi
    patch -p1 -i ../patches/permissive/librewolf-policies.patch
    if [ $? -ne 0 ]; then exit 1; fi
    popd

    # create the final zip artifact
    rm -f librewolf-$pkgver.en-US.$ospkg-permissive.zip
    zip -qr9 librewolf-$pkgver.en-US.$ospkg-permissive.zip librewolf
    if [ $? -ne 0 ]; then exit 1; fi

    # now to try to make the installer
    # (create a .deb here)
fi

popd
