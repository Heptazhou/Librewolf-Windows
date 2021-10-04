.phony : all clean

all :

	cp version debian10/version && cp version debian11/version && cp version fedora/version && cp version ubuntu/version && cp version mint/version && cp version arch && cp version macos && cp version windows && cp version portable-linux

	make -C arch
	make -C macos
	make -C windows
	make -C portable-linux

	make -C debian10
	make -C debian11
	make -C fedora
	make -C mint
	make -C ubuntu


clean :
	rm -f version debian10/version debian11/version fedora/version ubuntu/version mint/version arch/version macos/version windows/version portable-linux/version
	make -C portable-linux clean

build.debian10 :
	make -C debian10
build.debian11 :
	make -C debian11
build.fedora :
	make -C fedora
build.mint :
	make -C mint
build.ubuntu :
	make -C ubuntu


build.arch :
	make -C arch
build.macos :
	make -C macos
build.windows :
	make -C windows

