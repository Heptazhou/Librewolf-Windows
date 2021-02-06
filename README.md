LibreWolf for Win64
-------------------

This repository is still a work in progress.

But we have a zip file and an installer available for testing right now..

Download link to this prerelease is:
* Zip file is: [librewolf-85.0.en-US.win64.zip](https://gitlab.com/librewolf-community/browser/windows/uploads/5e9d436515d315d4e8953f88bf02bd99/librewolf-85.0.en-US.win64.zip).
* The installer is: [librewolf-85.0.en-US.win64-setup.exe](https://gitlab.com/librewolf-community/browser/windows/uploads/ec6f7e7dc1096bf7730f503d856d3a9f/librewolf-85.0.en-US.win64-setup.exe).

Note: If your version of LibreWolf does _not_ run, an additional install of the [Microsoft Visual C++ 2010 Redistributable Package (x64)](https://www.microsoft.com/en-us/download/details.aspx?id=14632) might be required.

Building the package:
---------------------

For now, if you want to attempt to build, this build does require you to:

* First build the mozilla-unified as explained in the mozilla docs, using all the ./mach bootstrap stuff
* You can delete this mozilla-unified thing to save some space (try ./mach run on it just for fun)
* Then clone the windows repo
* cd into it, and build with: **time bash build.sh**
* You can perform each of the build steps individually and the overall script structure follows PKGBULD as used on Archlinux 
* This will produce a **librewolf-85.0.en-US.win64.zip** in this windows folder.

Once you have built the entire mozilla-unified with all the mach bootstrap stuff (which will
install the needed binaries in $HOME/.mozbuild), don't forget to copy the entire
C:\Program Files\Git folder to /c/mozilla-source to get a sed.exe that understands the -z option,
and to get sha256sum.exe.

build.sh
--------

You can perform all the steps on one go, or perform the build steps individually, to note:
* build.sh fetch prepare build package installer_win

To do:
------

* Listing known issues in this README.md
* Branding issues.
* Improve this README.md to contain better, detailed instructions on how to build.
* problem with old sed. does not recognize -z. using the one from Git might be a work around.


Branding issue: resource files
------------------------------

* This section is just some notes.
* Build fail on missing stubinstaller (might be a FF bug as it should just take missing
stuff from the nightly branding folder?)

```
$ mkdir stubinstaller
$ cp bgstub.jpg stubinstaller
$ pwd
/c/mozilla-source/firefox-85.0/browser/branding/librewolf
$

* checking all the different files in nightly and librewolf

$ cd nightly
$ find . | sort > /c/mozilla-source/branding-nightly.txt
$ cd ../librewolf/
$ find . | sort > /c/mozilla-source/branding-librewolf.txt


$ diff branding-nightly.txt branding-librewolf.txt
4a5,6
> ./bgstub.jpg
> ./bgstub_2x.jpg
7a10
> ./content/about-background.png
9,10d11
< ./content/about-logo.svg
< ./content/about-logo@2x.png
14,15d14
< ./content/aboutlogins.svg
< ./content/firefox-wordmark.svg
22,24d20
< ./default22.png
< ./default24.png
< ./default256.png
$
```
