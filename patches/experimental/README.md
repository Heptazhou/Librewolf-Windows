# current differences between -release and -experimental

## librewolf.cfg:

* lockPref("dom.w3c_pointer_events.enabled", true); -> This fixes YouTube picture-in-picture.
* defaultPref("dom.event.contextmenu.enabled", true); -> This fixes lastpass.com context menu.
* Comment out all WebGL related settings to enable WebGL again.

## policies.json

* Added the decentraleyes plugin.
