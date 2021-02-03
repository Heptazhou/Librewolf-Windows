Just some notes
---------------

Once you have built the entire mozilla-unified with all the mach bootstrap stuff (which will
install the needed binaries in $HOME/.mozbuild), don't forget to copy the entire
C:\Program Files\Git folder to /c/mozilla-source to get a sed.exe that understands the -z option,
and to get sha256sum.exe.


To build, one should use the following command in the checked out windows repo:

$ time bash build.sh fetch prepare build package


the final .zip is in:
  C:\mozilla-source\windows


* problem with old sed. does not recognize -z. using the one from Git might be a work around.


BRANDING: resource files
========================

* build fail on missing stubinstaller (might be a FF bug as it should just take missing
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

