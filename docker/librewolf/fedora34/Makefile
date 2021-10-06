all :
	sudo docker build -t librewolf/release-fedora34 .
	make -C rpm all

no-cache :
	sudo docker build --no-cache -t librewolf/release-fedora34 .
	make -C rpm no-cache

clean :
	make -C rpm clean
