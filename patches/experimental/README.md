# current differences between -release and -experimental

## librewolf.cfg:

* lockPref("dom.w3c_pointer_events.enabled", true); -> This fixes YouTube picture-in-picture.
* defaultPref("dom.event.contextmenu.enabled", true); -> This fixes lastpass.com context menu.
* defaultPref("extensions.update.url", ""); -> enable in-app check manual check for extension updates.


## policies.json

* Added the decentraleyes plugin.
