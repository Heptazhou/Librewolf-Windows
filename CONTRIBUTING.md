Compiling
---------

To compile on Windows, you need to:

* Install Mozilla build setup tools: [here]().
* Install Microsoft visual studio community edition [here]().
* Within Visual Studio, setup the Blah API.

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
