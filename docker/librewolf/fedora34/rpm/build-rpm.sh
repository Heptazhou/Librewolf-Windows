rm -rf /WORK
mkdir /WORK
cd /WORK

version=$(cat ../version)

echo '---'
echo "--- LibreWolf version file is: $version"
echo '---'
echo '--- Contents of /artifacts folder:'
ls -la /artifacts
echo '---'
echo '--- Contents of /WORK folder:'
ls -la /WORK
echo '---'




rm -rf rpmbuild
mkdir -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

sed "s/__VERSION__/$version/g" < /librewolf.spec > rpmbuild/SPECS/librewolf.spec

cp -v /artifacts/librewolf-$version.en-US.rpm.zip rpmbuild/SOURCES/librewolf.zip
cd rpmbuild/SOURCES

unzip librewolf.zip
rm librewolf.zip

mkdir -p librewolf-$version/usr/share/librewolf
mkdir -p librewolf-$version/usr/bin

mv -v librewolf/* librewolf-$version/usr/share/librewolf
rmdir librewolf
cd librewolf-$version/usr/bin
ln -s ../share/librewolf/librewolf
cd ../../..

# Application icon
mkdir -p librewolf-$version/usr/share/applications
mkdir -p librewolf-$version/usr/share/icons
cp -v librewolf-$version/usr/share/librewolf/browser/chrome/icons/default/default64.png librewolf-$version/usr/share/icons/librewolf.png
sed "s/MYDIR/\/usr\/share\/librewolf/g" < librewolf-$version/usr/share/librewolf/start-librewolf.desktop.in > librewolf-$version/usr/share/applications/librewolf.desktop


tar cvfz lw.tar.gz librewolf-$version
# todo perhaps: rm -rf librwolf-$version

cd ../..

rm -rf $HOME/rpmbuild
cp -rv rpmbuild $HOME

# Build the package!
echo '---'
echo "[debug] Running rpmbuild.."
echo '---'

rpmbuild -v -ba $(pwd)/rpmbuild/SPECS/librewolf.spec
echo '--- [debug] Copying output files to /artifacts'
cp -v ~/rpmbuild/RPMS/x86_64/librewolf-*.rpm /artifacts
cp -v ~/rpmbuild/SRPMS/librewolf-*.rpm /artifacts
