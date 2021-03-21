#!/usr/bin/bash

# sanity checks
if [ ! -d obj-x86_64-pc-linux-gnu/dist/firefox ]; then
    echo "installer_rpm.sh: directory obj-x86_64-pc-linux-gnu/dist/firefox not found."
    exit 1;
fi

rm -rf ../firefox ../librewolf
cp -r obj-x86_64-pc-linux-gnu/dist/firefox ..


pushd ..
mv firefox librewolf

# apply the LibreWolf settings
cp -rv settings/* librewolf
# rename the executable manually
cd librewolf ; mv -v firefox librewolf ; cd ..
    
# recreate the zip file..

# clean garbage files
cd librewolf ; rm -rf maintenanceservice* pingsender* firefox.*.xml precomplete removed-files ; cd ..

# copy the files to register LibreWolf as local app.
cp -v branding_files/register-librewolf branding_files/start-librewolf* librewolf

# be sure to remove the previous zip file..
rm -f librewolf-$pkgver.en-US.rpm.zip*

zip -r9 librewolf-$pkgver.en-US.rpm.zip librewolf
if [ $? -ne 0 ]; then exit 1; fi
sha256sum librewolf-$pkgver.en-US.rpm.zip > librewolf-$pkgver.en-US.rpm.zip.sha256sum
if [ $? -ne 0 ]; then exit 1; fi


popd
