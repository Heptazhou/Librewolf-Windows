This repository is still a work in progress.

But we have a zip file available for testing right now..

Download link to the prerelease alpha zip file is [here](https://gitlab.com/librewolf-community/browser/windows/uploads/5e9d436515d315d4e8953f88bf02bd99/librewolf-85.0.en-US.win64.zip).

To do:

* Creating an installer.
* Branding issues, include a good icon for librewolf.exe
* Other Branding Issues
* Improve this README.md to contain detailed instructions on how to build.

For now, if you want to attempt to build, this build does require you to:

* First build the mozilla-unified as explained in the mozilla docs, using all the ./mach bootstrap stuff
* You can delete this mozilla-unified thing to save some space (try ./mach run on it just for fun)
* Then clone the windows repo
* cd into it, and build with: **time bash build.sh fetch prepare build package installer_win**
* you can perform each of the build steps individually and the overall script structure follows PKGBULD as used on Archlinux 
* This will produce a **librewolf-85.0.en-US.win64.zip** in this windows folder.

