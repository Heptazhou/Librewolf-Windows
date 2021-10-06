all :
	sudo docker build -t librewolf/release-ubuntu20 .
	make -C deb all

no-cache :
	sudo docker build --no-cache -t librewolf/release-ubuntu20 .
	make -C deb no-cache

clean :
	make -C deb clean
