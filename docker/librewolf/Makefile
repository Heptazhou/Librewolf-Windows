.phony : all clean

all :

	cp ../version .
	cp version debian10/version && cp version debian11/version && cp version fedora34/version && cp version ubuntu20/version && cp version mint20/version && cp version arch && cp version macos && cp version windows && cp version portable-linux

	make -C arch
	make -C macos
	make -C windows
	make -C portable-linux

	make -C debian10
	make -C debian11
	make -C fedora34
	make -C mint20
	make -C ubuntu20
	make -C windows

clean :
	rm -f version debian10/version debian11/version fedora34/version ubuntu20/version mint20/version arch/version macos/version windows/version portable-linux/version
	make -C portable-linux clean
	make -C debian10 clean
	make -C debian11 clean
	make -C fedora34 clean
	make -C mint20 clean
	make -C ubuntu20 clean
	make -C windows clean

build.debian10 :
	cp version debian10
	make -C debian10
build.debian11 :
	cp version debian11
	make -C debian11
build.fedora34 :
	cm version fedora34
	make -C fedora34
build.mint20 :
	cp version mint20
	make -C mint20
build.ubuntu :
	cp version ubuntu20
	make -C ubuntu20


build.arch :
	cp version arch
	make -C arch
build.macos :
	cp version macos
	make -C macos
build.windows :
	cp version windows
	make -C windows

