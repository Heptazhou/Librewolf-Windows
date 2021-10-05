version=$(cat version)

rm -rf rpmbuild
mkdir -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

sed "s/__VERSION__/$version/g" < librewolf.spec > rpmbuild/SPECS/librewolf.spec

cp -v artifacts/librewolf-$version.en-US.fedora.zip rpmbuild/SOURCES/librewolf.zip
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

tar cvfz lw.tar.gz librewolf-$version

cd librewolf-$version
find . > ../../../lw-dir.txt
cd ..

rm -rf lw
cd ../..

rm -rf ~/rpmbuild
cp -rv rpmbuild ~

# Build the package!
echo "[debug] Running rpmbuild.."
rpmbuild -v -bb $(pwd)/rpmbuild/SPECS/librewolf.spec
cp -v ~/rpmbuild/RPMS/x86_64/librewolf-*.rpm artifacts
