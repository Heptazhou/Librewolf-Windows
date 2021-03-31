# current differences between -release and -permissive

## librewolf.cfg:

* lockPref("dom.w3c_pointer_events.enabled", true); -> This fixes YouTube picture-in-picture.

* defaultPref("dom.event.contextmenu.enabled", true); -> This fixes lastpass.com context menu.

* defaultPref("extensions.update.url", ""); -> enable in-app manual check for extension updates.

* Attempting new cookie behavior (use Settings > Cookies and Site Data > Manage Exceptions), these are the last three preferences in the cfg file: privacy.clearOnShutdown.cookies, privacy.clearOnShutdown.offlineApps, network.cookie.lifetimePolicy.


## policies.json

* Added the decentraleyes plugin.
