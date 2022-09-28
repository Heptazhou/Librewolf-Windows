# [Download latest release](https://gitlab.com/librewolf-community/browser/windows/-/releases)

* Visit [the FAQ](https://librewolf.net/docs/faq/).
* Install via _[chocolatey](https://community.chocolatey.org/packages/librewolf)_: `choco install librewolf`
* Or install via _winget_: `winget install librewolf`
* Or install via _[scoop](https://scoop.sh)_: `scoop bucket add extras`, then `scoop install librewolf`

# Update plugins
There are plugins that help update librewolf, which helps improve securitiy.

* Guillaume created a windows updater script for the Task Scheduler. it can be found [here](https://github.com/ltGuillaume/LibreWolf-WinUpdater).
* Defkev created a LibreWolf updater plugin, which can be found [here](https://addons.mozilla.org/en-US/firefox/addon/librewolf-updater/).

# Linux builds

Tested on: fedora36, ubuntu22
vm/vps minimal-ish specs:

* 4 core cpu
* 17gb RAM
* 50gb storage

It's mostly a matter of doing once:
```
## pick build type:
# cd linux
# cd linux-mar

make fetch

## pick your os:
# sudo make setup-fedora
# sudo make setup-debian

make bootstrap
```
Then, to build:
```
make all
```
That should produce the (non-updating) setup.exe and the community portable zip. There is a second directory `linux-mar` where you can build the so-called `.mar` version of LibreWolf. This is te version that will be auto-updating someday. It's great, but it's main drawback is theming bugs. 

You can force a rebuild with `make clean all`. Please always use `make fetch` as a single make command, else there might be bugs in the version files.

# LibreWolf for windows


* **If your LibreWolf crashes on startup**, you're probably missing the right [Visual C++ Runtime](https://support.microsoft.com/en-us/topic/the-latest-supported-visual-c-downloads-2647da03-1eea-4433-9aff-95f26a218cc0). You'll want the _Visual Studio 2015, 2017 and 2019_ version for **x64**, which would be **[this file](https://aka.ms/vs/16/release/vc_redist.x64.exe)**.
* The latest type of **.zip files** allows for a user profile inside the extracted folder. It is _self-contained_ and runs on removable storage.

# Where to submit tickets

* For all **about:config** and **librewolf.cfg** issues, go here: [[settings repository](https://gitlab.com/librewolf-community/settings/-/issues)].
* For _all other issues_ and **setup/install** issues, go here: [[issues for windows repository](https://gitlab.com/librewolf-community/browser/windows/-/issues)].

# Community links
* [[reddit](https://www.reddit.com/r/LibreWolf/)] - [r/LibreWolf](https://www.reddit.com/r/LibreWolf/) 😺
* [[gitter](https://gitter.im/librewolf-community/librewolf)], and the same room on [matrix](https://app.element.io/#/room/#librewolf-community_librewolf:gitter.im) (element.io).
* The install instructions for Windows on [librewolf.net](https://librewolf.net/installation/windows/).

# Compiling the windows version

(With the arrival of the linux cross-compiled builds, this is no longer preferred.)

This segment is for people who want to build LibreWolf for themselves. The build of the LibreWolf source tarball is in public CI, so you can use that. Given that you have followed the steps in the Mozilla setup guide:

* [Building Firefox On Windows](https://firefox-source-docs.mozilla.org/setup/windows_build.html)

Once that works, you can check out and compile LibreWolf like this:

```
git clone https://gitlab.com/librewolf-community/browser/windows.git
cd windows
make fetch build
```

Currently a bug in `./mach package` makes this build fail, but it did produce the distribution .zip file that we're after. So after this, you can just:

```
make artifacts
```
This will produce the -setup.exe and portable .zip. Have fun!

# Uploading a release

To actually submit these artifacts to the Windows repository as release files, use:
```
python3 mk.py upload <token>
```
