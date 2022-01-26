# LibreWolf for windows

* **[download latest release](https://gitlab.com/librewolf-community/browser/windows/-/releases)**
* Visit [the FAQ](https://librewolf.net/docs/faq/).
* Install via _[chocolatey](https://community.chocolatey.org/packages/librewolf)_: `choco install librewolf`
* or install via _winget_: `winget install librewolf`
* **If your LibreWolf crashes on startup**, you probably miss the right [Visual C++ Runtime](https://support.microsoft.com/en-us/topic/the-latest-supported-visual-c-downloads-2647da03-1eea-4433-9aff-95f26a218cc0). You want the _Visual Studio 2015, 2017 and 2019_ version for **x64**, which would be **[this file](https://aka.ms/vs/16/release/vc_redist.x64.exe)**.
* The .zip files are _'portable zip files'_ that allows for a user profile in the extracted zip file folders. It is _self-contained_.

# Where to submit tickets

* For all **about:config** and **librewolf.cfg** issues, go here: [[settings repository](https://gitlab.com/librewolf-community/settings/-/issues)].
* For _all other issues_ and **setup/install** issues, go here: [[issues for windows repository](https://gitlab.com/librewolf-community/browser/windows/-/issues)].

# Community links
* [[reddit](https://www.reddit.com/r/LibreWolf/)] - [r/LibreWolf](https://www.reddit.com/r/LibreWolf/) 😺
* [[gitter](https://gitter.im/librewolf-community/librewolf)], and the same room on [matrix](https://app.element.io/#/room/#librewolf-community_librewolf:gitter.im) (element.io).
* The install instructions for Windows on [librewolf.net](https://librewolf.net/installation/windows/).

# Community contributions

* Guillaume created a windows updater script for the Task Scheduler. You might find this handy, and it can be found [here](https://github.com/ltGuillaume/LibreWolf-WinUpdater).

# Compiling the windows version

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
This would involve having a valid token, ofcourse, but also something more: [Git for Windows](https://git-scm.com/). From this package, we only need `sha256sum.exe` to calculate our checksums. Mozilla provides only `md5sum.exe` in their very old version of the mingw tools. Simply installing Git won't be enough to get `sha256sum.exe` in our path, the `C:\mozilla-build\start-shell.bat` file needs a little tweak at line 55, to read:
```
SET "PATH=%PATH%;!GITDIR!;c:\Program Files\Git\usr\bin"
```
This should put `sha256sum.exe` in your path.
