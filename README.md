# [Download latest release](https://gitlab.com/librewolf-community/browser/windows/-/releases)

* Visit [the FAQ](https://librewolf.net/docs/faq/).
* Install via _[chocolatey](https://community.chocolatey.org/packages/librewolf)_: `choco install librewolf`
* Or install via _winget_: `winget install librewolf`
* Or install via _[scoop](https://scoop.sh)_: `scoop bucket add extras`, then `scoop install librewolf`

# Update tools
There are several tools that can help you to keep LibreWolf up-to-date, which helps improve security.

* @ltguillaume created an *automatic updater* that can either be run manually or be set up to automatically update via a scheduled task. It can be found [here on Codeberg](https://codeberg.org/ltguillaume/librewolf-winupdater) or [on GitHub](https://github.com/ltguillaume/librewolf-winupdater). 
* Defkev created a LibreWolf *update checker extension*, which can be found [here](https://addons.mozilla.org/en-US/firefox/addon/librewolf-updater/). It will show a notification when an update is available and guide you to the download link.

Please note the distinction between the *updater* ([LibreWolf WinUpdater](https://codeberg.org/ltguillaume/librewolf-winupdater)) and the *extension* ([LibreWolf Updater](https://addons.mozilla.org/en-US/firefox/addon/librewolf-updater/)), in that the updater can _install_ updates automatically, while the extension can only _check_ for updates. There has been some confusion about that on Reddit, GitHub and Gitlab.

Due to problems with the Gitlab CI, we _can't_ build the two `ahk-tools` ([AutoHotkey](https://www.autohotkey.com) scripts) used in the portable 
version directly from source while building the portable zip. The tools are instead pre-built by @ltguillaume and downloaded from their respective project pages on Codeberg, [LibreWolf Portable](https://codeberg.org/ltguillaume/librewolf-portable/releases) and [LibreWolf WinUpdater](https://codeberg.org/ltguillaume/librewolf-winupdater/releases).

# LibreWolf for Windows

* LibreWolf has many UI languages built-in, available in the settings.
* The latest **-portable.zip** release type is _self-contained_, can be moved around and (thus) be run on removable storage. It can be run next to an installed version of LibreWolf and supports (multiple) user profiles inside the extracted folder. Head to the [launcher's project page](https://codeberg.org/ltguillaume/librewolf-portable) to find out how this works.

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
cd windows/winbuild
make all
```

This will produce the -setup.exe and portable .zip. Have fun!

