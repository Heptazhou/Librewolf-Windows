# Crosscompile on linux (debian,fedora)



#
# Creating the crosscompile environment on linux
#



setup_deb_root() {
    echo "setup_deb_root: begin."

    # (implementation...)
    
    echo "setup_deb_root: done."
}
setup_deb_user() {
    echo "setup_deb_user: begin."

    # (implementation...)
    
    echo "setup_deb_user: done."
}
setup_rpm_root() {
    echo "setup_rpm_root: begin."

    # (implementation...)
    
    echo "setup_rpm_root: done."
}
setup_rpm_user() {
    echo "setup_rpm_user: begin."

    # (implementation...)
    
    echo "setup_rpm_user: done."
}






#
# linux_patches() and linux_artifacts()
#







linux_patches() {
    mozconfig_mode=xcompile
    do_patches
}



linux_artifacts_details() {
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

# create the final zip artifact
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
    rm -f librewolf-$pkgver.en-US.win64-permissive-setup.exe tmp-permissive.nsi
    sed "s/win64-setup/win64-permissive-setup/g" < tmp.nsi > tmp-permissive.nsi
    makensis-3.01.exe -V1 tmp-permissive.nsi
    if [ $? -ne 0 ]; then exit 1; fi
fi

popd
}


linux_artifacts() {
    echo "linux_artifacts: begin."

    if [ ! -d firefox-$pkgver ]; then exit 1; fi
    cd firefox-$pkgver

    ./mach package
    if [ $? -ne 0 ]; then exit 1; fi
    
    echo ""
    echo "artifacts_win: Creating final artifacts."
    echo ""
    
    linux_artifacts_details

    cd ..
    
    echo "linux_artifacts: done."
}
