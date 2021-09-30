.phony : all clean debian fedora mint ubuntu arch macos windows

all :

	cp version appimage/version && cp version flatpak/version && cp version snapd/version

	make -C appimage
	make -C flatpak
	make -C snapd

clean :
	rm -f version appimage/version flatpak/version snapd/version


build.appimage :
	make -C appimage
build.flatpak :
	make -C flatpak
build.snapd :
	make -C snapd
