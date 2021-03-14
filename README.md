LibreWolf for Win64
-------------------

We have a zip file and an installer available for download.. We no longer consider these builds alpha quality, but it is not out of beta yet either.

**Downloads**: To get the installer, head over to the **[releases](https://gitlab.com/librewolf-community/browser/windows/-/releases)** page.

Note: If your version of LibreWolf does _not_ run, an additional install of the [vc_redist.x64.exe](https://aka.ms/vs/16/release/VC_redist.x64.exe) component might be required.

This repository is for the windows installer, this repo is not for _librewolf.cfg_ issues, that goes [here](https://gitlab.com/librewolf-community/settings). These config file settings are system-wide for all users.

## .plan

1. Make LibreWolf compile better and squash the bugs related to building Firefox correctly. (with our current and future patches)
2. Transfer this build process to Gitlab public shared linux runners so the entire build process is transparent. (for windows, cross-compilation)
3. Keep up to date with the best hardening/security/privacy practices and/or patches, keeping in mind usability. (the fun part!)
4. Goto 3
