# [Download latest release](https://gitlab.com/librewolf-community/browser/windows/-/releases)

* Visit [the FAQ](https://librewolf.net/docs/faq/).
* Install via _[chocolatey](https://community.chocolatey.org/packages/librewolf)_: `choco install librewolf`
* Or install via _winget_: `winget install librewolf`
* Or install via _[scoop](https://scoop.sh)_: `scoop bucket add extras`, then `scoop install librewolf`

# Update plugins
There are plugins that help update librewolf, which helps improve securitiy.



* Guillaume created a windows *updater script* for the Task Scheduler. it can be found [here](https://github.com/ltGuillaume/LibreWolf-WinUpdater). 
* Defkev created a LibreWolf *updater plugin*, which can be found [here](https://addons.mozilla.org/en-US/firefox/addon/librewolf-updater/).

Please note the distinction between the *task scheduler updater script* ([LibreWolf-WinUpdater](https://github.com/ltGuillaume/LibreWolf-WinUpdater)) and the *librewolf extension* ([LibreWolf Updater](https://addons.mozilla.org/en-US/firefox/addon/librewolf-updater/)), in that the latter only checks for updates, but will not install them automatically, while the former does. There's quite a bit of confusion about that on Reddit, GitHub and Gitlab.


# LibreWolf for windows

* The latest type of **.zip files** allows for a user profile inside the extracted folder. It is _self-contained_ and runs on removable storage. LibreWolf has many ui languages built-in, available in the settings.

# Where to submit tickets

* When you have problems with the Settings, or the Advanced Settings (`about:config`), please submit these issues to the [settings repository](https://gitlab.com/librewolf-community/settings/-/issues).
* For all other problems, such as crashes/theme issues/graphics/speed problems, please submit them to [issues for windows repository](https://gitlab.com/librewolf-community/browser/windows/-/issues).

# Linux builds

Tested on: fedora36, ubuntu22
vm/vps minimal-ish specs:

* 4 core cpu
* 17gb RAM
* 50gb storage

On the commandline, it's mostly a matter of doing once:
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
That should produce the (non-updating) setup.exe and the community portable zip. 

There is a second directory `linux-mar` where you can build the so-called `.mar` version of LibreWolf. This is te version that will be auto-updating someday. It's great, but it's main drawback is theming bugs. 

You can force a rebuild with `make clean all`. Please always use `make fetch` as a single make command, else there might be bugs in the version files. The `make fetch` command gets you the current latest version.

# Compiling the windows version natively

(With the arrival of the linux cross-compiled builds, this is no longer preferred.)

This segment is for people who want to build LibreWolf for themselves. The build of the LibreWolf source tarball is in public CI, so you can use that. Given that you have followed the steps in the Mozilla setup guide:

* [Building Firefox On Windows](https://firefox-source-docs.mozilla.org/setup/windows_build.html)

Once that works, you can check out and compile LibreWolf like this:

```
git clone https://gitlab.com/librewolf-community/browser/windows.git
cd windows
make fetch build artifacts
```

This will produce the -setup.exe and portable .zip. Have fun!
