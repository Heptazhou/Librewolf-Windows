* This stuff below works for netflix and prime video.

fabrizio @fxbrit_gitlab 11:59


I think we should remove from .cfg

    defaultPref("media.gmp-manager.url", "data:text/plain,");
    defaultPref("media.gmp-manager.url.override", "data:text/plain,");
    defaultPref("media.gmp-manager.certs.2.commonName", "");
    defaultPref("media.gmp-manager.certs.1.commonName", "");
as they are overkill

then we should also remove from .cfg

    defaultPref("media.gmp-manager.updateEnabled", false);
    defaultPref("media.gmp-widevinecdm.autoupdate", false);
    defaultPref("media.gmp-eme-adobe.enabled", false);

as they do not appear by default in recent firefox versions and are introduced by our .cfg

With these modifications in place I went in about:config and did

    defaultPref("media.eme.enabled", true);
    defaultPref("media.gmp-widevinecdm.enabled", true);
    defaultPref("media.gmp-widevinecdm.visible", true);
    defaultPref("media.gmp-provider.enabled", true);

when opening primevideo the video loaded with no required effort on my side

I think the only issue left, at least on prime video, is that the user agent makes it think that the browser is outdated and therefore it disables media reproduction at high quality
I think I'm stuck at 720 or 1080 either

let's see if netflix works on my side
yes! it works :)
