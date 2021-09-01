Hi all, this document tries to summarize all changes we would like to see in the website.

# https://gitlab.com/librewolf-community/librewolf-community.gitlab.io/-/blob/master/content/install.md
url = https://librewolf-community.gitlab.io/install/

** Compiling from source **
* Compiling from source is now possible for all versions of LibreWolf, just head over to the relevant repository, clone it, and read the README.md

** macOS: **
* (Remove the current section completely.)
* The macOS version builds from source, and has a .dmg available.
* No automatic updating.
* Have a link to the repository: https://gitlab.com/librewolf-community/browser/macos 
* Have a link to the releases: https://gitlab.com/librewolf-community/browser/macos/-/releases
* Link to the _build guide_: https://gitlab.com/librewolf-community/browser/macos/-/blob/master/build_guide.md

** Windows: **
* (Remove the current section completely.)
* The Windows version builds from source, and has a -setup.exe available.
* No automatic updating.
* Have a link to the repository: https://gitlab.com/librewolf-community/browser/windows
* Have a link to the releases: https://gitlab.com/librewolf-community/browser/windows/-/releases 

# https://gitlab.com/librewolf-community/docs/-/blob/master/_index.md
url = https://librewolf-community.gitlab.io/docs/

** Features **
* Does LibreWolf still have an 'extensions firewall'?

** Download and Installation **
* Remove the TODO and help needed line and please get in toch below windows. 
* Just the good, up to date links to the download loctions

** Contributions **
* Typo: chance 'currently unsupported browser' into 'currently unsupported platform/operating system'.

# https://gitlab.com/librewolf-community/docs/-/blob/master/addons.md
url = https://librewolf-community.gitlab.io/docs/addons/

* (Discussion pending.)

** Recommended Addons **
* add as first one: [NoScript](https://addons.mozilla.org/en-US/firefox/addon/noscript/) Block JavaScript.
* add second: [uMatrix](https://addons.mozilla.org/en-US/firefox/addon/umatrix/) Note: uMatrix development has frozen, but it gives more control than NoScript, use either uMatrix or NoScript.
* add [LocalCDN](https://addons.mozilla.org/en-US/firefox/addon/localcdn-fork-of-decentraleyes/)
* add Bitwarden add-on [add-on page](https://addons.mozilla.org/en-US/firefox/addon/bitwarden-password-manager/)
* remove Browser Plugs Privacy Firewall (dead link)
* remove uBlock stuff (see section below)

** new: uBlock Origin tweaks **
* we should consider linking to ublock guide for advanced modes, and probably to at least one filter list that works against cryptomining and ones that removes url tracking (which is a good replacement to addons like clearURLs, don't track me google etc)
* with regards to nano/nanoblocker: we should probably just remove it completely from the list; basically the new owners made it malicious.
* good blocklist agains crypto-mining: [NoCoin adblock list](https://github.com/hoshsadiq/adblock-nocoin-list).
* a collection of filter lists that are available on filterlists.com: https://github.com/DandelionSprout/adfilt/discussions/163
* if you have the patience to fix a few websites when they break the medium mode is a really good balance between protection an usability imo: https://github.com/gorhill/uBlock/wiki/Blocking-mode:-medium-mode
* I'll change it to add a 'ublock tweaks' section, could you pass a link to that Wiki? here it is: https://github.com/gorhill/uBlock/wiki

ok I collected what I would consider the essential links to understand how uBlock Origin works, I kept it pretty slim as it's already a lot to take:
* easy mode, the default mode that we ship with the browser -> https://github.com/gorhill/uBlock/wiki/Blocking-mode:-easy-mode
* how to add your own static filters, which should be included as we suggest filterlists -> https://github.com/gorhill/uBlock/wiki/Filter-lists-from-around-the-web
* dynamic filtering, suggested for enhanced protection -> https://github.com/gorhill/uBlock/wiki/Dynamic-filtering:-quick-guide
* medium mode, suggested for enhanced protection, might require to fix some websites manually ->
https://github.com/gorhill/uBlock/wiki/Blocking-mode:-medium-mode



** Recommended Addons Settings **
* remove 'cookie master' as it should be done in librewolf.cfg
* remove 'User Agent Platform Spoofer', is done in librewolf.cfg
* remove 'browser plugs privacy firewal' (dead link)
* And the verbatim block below it is also obsolete.

** Other Addons **

*** Privacy addons ***
* discussion
* proposal: add a section 'Container addons' and put all container stuff in there: Google-Container, Facebook-Container, Mozilla-Multi-Account-Containers, Switch-Containers, Temporary-Containers)
* remove noHTTP (builtin with latest firefox)
* remove Decentraleyes (old not effective), replace with: [LocalCDN](https://addons.mozilla.org/en-US/firefox/addon/localcdn-fork-of-decentraleyes/)
* remove Request Blocker
* remove Cookie Quik Manager

*** Other useful addons ***
* discussion
* add [Dark Reader](https://addons.mozilla.org/en-US/firefox/addon/darkreader/). Can aid visually impaired people.
* remove Dormancy, why would we want to recommend this?
* Add custom search engine: why would we want this?
* remove UndoCloseTabButton: why would we want to recommend this?
* Advanced Github Notifier: why would we..
* Shortkeys: why? also not security oriented.

# https://gitlab.com/librewolf-community/docs/-/blob/master/testing.md
url = https://librewolf-community.gitlab.io/docs/testing/

** Security/Fingerprint **

* add [Cover Your Tracks](https://coveryourtracks.eff.org/), perhaps a bit prominently.




