function artifacts_win_details(){
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

# windows: copy the windows icon
cp -v common/source_files/browser/branding/librewolf/firefox.ico librewolf/librewolf.ico

# create the final zip/exe artifacts
if [ -z $strict ]; then
    rm -f librewolf-$pkgver.en-US.$ospkg.zip
    zip -qr9 librewolf-$pkgver.en-US.$ospkg.zip librewolf
    if [ $? -ne 0 ]; then exit 1; fi

    # now to try to make the installer
    rm -f librewolf-$pkgver.en-US.win64-setup.exe tmp.nsi
    sed "s/pkg_version/$pkgver/g" < artifacts_win.nsi > tmp.nsi
    makensis-3.01.exe -V1 tmp.nsi
    if [ $? -ne 0 ]; then exit 1; fi
    
    # patch to permissive config
    if [ ! -z $permissive ]; then
	pushd librewolf
	echo "Applying permissive patches..."
	cp -v ../settings/librewolf.cfg . && cp -v ../settings/distribution/policies.json distribution
	patch -p1 -i ../patches/permissive/librewolf-config.patch
	patch -p1 -i ../patches/permissive/librewolf-policies.patch
	popd

	# create the final zip artifact
	rm -f librewolf-$pkgver.en-US.$ospkg-permissive.zip
	zip -qr9 librewolf-$pkgver.en-US.$ospkg-permissive.zip librewolf
	if [ $? -ne 0 ]; then exit 1; fi

	# now to try to make the installer
	rm -f librewolf-$pkgver.en-US.win64-permissive-setup.exe tmp-permissive.nsi
	sed "s/win64-setup/win64-permissive-setup/g" < tmp.nsi > tmp-permissive.nsi
	makensis-3.01.exe -V1 tmp-permissive.nsi
	if [ $? -ne 0 ]; then exit 1; fi
    fi
    
else

    # patch to strict config
    pushd librewolf
    echo "Applying strict config..."
    cp -v ../settings/librewolf.cfg . && cp -v ../settings/distribution/policies.json distribution
    patch -p1 -i ../patches/strict/librewolf-config.patch
    patch -p1 -i ../patches/strict/librewolf-policies.patch
    popd

    # create the final zip artifact
    rm -f librewolf-$pkgver.en-US.$ospkg-strict.zip
    zip -qr9 librewolf-$pkgver.en-US.$ospkg-strict.zip librewolf
    if [ $? -ne 0 ]; then exit 1; fi

    # now to try to make the installer
    rm -f librewolf-$pkgver.en-US.win64-strict-setup.exe tmp-strict.nsi
    sed "s/pkg_version/$pkgver/g" < artifacts_win.nsi > tmp.nsi
    sed "s/win64-setup/win64-strict-setup/g" < tmp.nsi > tmp-strict.nsi
    makensis-3.01.exe -V1 tmp-strict.nsi
    if [ $? -ne 0 ]; then exit 1; fi

fi

popd
}









function artifacts_deb_details(){
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
cp files/register-librewolf files/start-librewolf files/start-librewolf.desktop.in librewolf

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
    cp -v ../settings/librewolf.cfg . && cp -v ../settings/distribution/policies.json distribution
    patch -p1 -i ../patches/permissive/librewolf-config.patch
    patch -p1 -i ../patches/permissive/librewolf-policies.patch
    popd

    # create the final zip artifact
    rm -f librewolf-$pkgver.en-US.$ospkg-permissive.zip
    zip -qr9 librewolf-$pkgver.en-US.$ospkg-permissive.zip librewolf
    if [ $? -ne 0 ]; then exit 1; fi

    # now to try to make the installer
    # (create a .deb here)
fi

popd
}











function artifacts_rpm_details(){
exe=
objdir=obj-x86_64-pc-linux-gnu/dist/firefox
ospkg=rpm

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
cp files/register-librewolf files/start-librewolf files/start-librewolf.desktop.in librewolf


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
    cp -v ../settings/librewolf.cfg . && cp -v ../settings/distribution/policies.json distribution
    patch -p1 -i ../patches/permissive/librewolf-config.patch
    patch -p1 -i ../patches/permissive/librewolf-policies.patch
    popd

    # create the final zip artifact
    rm -f librewolf-$pkgver.en-US.$ospkg-permissive.zip
    zip -qr9 librewolf-$pkgver.en-US.$ospkg-permissive.zip librewolf
    if [ $? -ne 0 ]; then exit 1; fi

    # now to try to make the installer
    # (create a .deb here)
fi

popd
}





