Things to do:
-------------

These are ordered by priority:

* IPV6 issues, it's not working properly?
* Create an HOW_TO_BUILD.md to contain better, detailed instructions on how to build.
* Branding issues. We're going to need an MR with [LibreWolf / Browser / Common](https://gitlab.com/librewolf-community/browser/common) at some point.
* problem with old sed. does not recognize -z. using the one from Git might be a work around.
* What IP address does LW show on my sb site, and why does it show anything at all when Bing does show
the ip address of my nginx? what header stuff is going on?
* why does this anoying thing happen to my 'copy username' menu in lastpass (the local menu shows up)
* Theme AspenGlow: why does the three buttons disapear when i use the underwater screen ctrl-shift-i / Looks like a windows issue for now.

Notes on the branding issue(s):
-------------------------------

* This section is just some notes.
* Build fail on missing stubinstaller (might be a FF bug as it should just take missing
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

