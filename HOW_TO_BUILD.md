
Building the package:
---------------------

For now, if you want to attempt to build, this build does require you to:

* First build the mozilla-unified as explained in the mozilla docs, using all the ./mach bootstrap stuff
* You can delete this mozilla-unified thing to save some space (try ./mach run on it just for fun)
* Then clone the windows repo:
```
git clone --recursive https://gitlab.com/librewolf-community/browser/windows.git
```
* cd into it, and build with:
```
bash build.sh
```
* You can perform each of the build steps individually and the overall script structure follows PKGBULD as used on Archlinux 
* This will produce a **librewolf-85.0.en-US.win64.zip** in this windows folder.

Once you have built the entire mozilla-unified with all the mach bootstrap stuff (which will
install the needed binaries in $HOME/.mozbuild), don't forget to copy the entire
C:\Program Files\Git folder to /c/mozilla-source to get a sed.exe that understands the -z option,
and to get sha256sum.exe.

build.sh
--------

You can perform all the steps on one go, or perform the build steps individually, to note:
```
bash build.sh fetch prepare build package installer_win
```
