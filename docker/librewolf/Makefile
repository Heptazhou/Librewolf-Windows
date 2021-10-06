.phony : all clean

all :

	cp version debian10/version && cp version debian11/version && cp version fedora/version && cp version ubuntu20/version && cp version mint20/version && cp version arch && cp version macos && cp version windows && cp version portable-linux

	make -C arch
	make -C macos
	make -C windows
	make -C portable-linux

	make -C debian10
	make -C debian11
	make -C fedora
	make -C mint20
	make -C ubuntu20


clean :
	rm -f version debian10/version debian11/version fedora/version ubuntu20/version mint20/version arch/version macos/version windows/version portable-linux/version
	make -C portable-linux clean
	make -C debian10 clean
	make -C debian11 clean
	make -C fedora clean
	make -C mint20 clean
	make -C ubuntu20 clean

build.debian10 :
	make -C debian10
build.debian11 :
	make -C debian11
build.fedora :
	make -C fedora
build.mint20 :
	make -C mint20
build.ubuntu :
	make -C ubuntu20


build.arch :
	make -C arch
build.macos :
	make -C macos
build.windows :
	make -C windows

