Building the package means first getting FF itself to build:
------------------------------------------------------------

These instructions are for an _interactive_ build.

* Follow the guidelines in the [Building Firefox On Windows](https://firefox-source-docs.mozilla.org/setup/windows_build.html) documentation from mozilla.org. And I actually recommend to follow this documentation until you have a working |mach run|. I also recommend using Git, not Mercurial, as we're going to need it later in our build.sh.
* Once you have built the entire mozilla-unified with all the mach bootstrap stuff (which will install the needed binaries in $HOME/.mozbuild), don't forget to copy the entire
C:\Program Files\Git folder to /c/mozilla-source to get a sed.exe that understands the -z option,
and to get sha256sum.exe.
* I also had to download/install in my appdata, python 3, a recent version (just search it), I ended up with the following command line:
```
C:/Users/librewolf/AppData/Local/Programs/Python/Python39/python.exe ./bootstrap.py --vcs=git --application-choice browser --no-interactive --no-system-changes
```
* You can now delete the mozilla-unified folder, or keep it, if you want to play with FF itself.
* Then clone the windows repo:
```
git clone --recursive https://gitlab.com/librewolf-community/browser/windows.git
```
* cd into it, and build with:
```
bash build.sh
```
* This should produce a zip and installer exe in your top folder.

build.sh
--------

You can perform all the steps on one go, or perform the build steps individually, to note:
```
bash build.sh fetch prepare build package installer_win
```
