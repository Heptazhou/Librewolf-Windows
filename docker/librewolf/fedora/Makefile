all :
	sudo docker build -t librewolf/release-fedora .
	make -C rpm all

no-cache :
	sudo docker build --no-cache -t librewolf/release-fedora .
	make -C rpm no-cache

