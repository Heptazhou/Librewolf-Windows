# [Download latest release](https://gitlab.com/librewolf-community/browser/bsys6/-/releases)

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

# Building from source

* Building from source is done using our `bsys` build system. It only supports cross-compiling from Linux to Windows. So building the windows version from within windows is not supported. Well, it's not tested but possible in principle.
