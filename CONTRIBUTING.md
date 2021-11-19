# How to contribute:

If you want to contribute, or just build from source yourself, below are the inistructions to do that. If there is something unclear please type your feedback in **[this ticket](https://gitlab.com/librewolf-community/browser/windows/-/issues/112)** and we can adress it.

## Reference documentation:

* [Building Firefox On Windows](https://firefox-source-docs.mozilla.org/setup/windows_build.html).

## Compiling:

To compile on Windows, you need to:

* Install Mozilla build setup tools: [MozillaBuildSetup-Latest.exe](https://ftp.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/MozillaBuildSetup-Latest.exe).
* Install Microsoft visual studio community edition: [here](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022).
* Within Visual Studio:
** Desktop development with C++.
** Windows 10 SDK (at least 10.0.19041.0).
** C++ ATL for v143 build tools (x86 and x64).

* Open start-shell terminal and basically do the following:
```
wget -q "https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py"
python3 bootstrap.py --no-interactive --application-choice=browser
```
If you choose to, you can now build Firefox Nightly as follows:
```
cd mozilla-unified
./mach build
./mach package
./mach run # or just run it..
```
Or you can just forget about that, and remove the firefox tree:
```
rm -rf bootstrap.py mozilla-unified
```
To build the current windows setup.exe, we do the following:
```
git clone --recursive https://gitlab.com/librewolf-community/browser/windows.git
cd windows
./build.py all
```
