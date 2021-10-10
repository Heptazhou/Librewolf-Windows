all :
	cp ../version .
	sudo docker build -t librewolf/release-windows .
#	make -C deb all

no-cache :
	cp ../version .
	sudo docker build --no-cache -t librewolf/release-windows .
#	make -C deb no-cache

clean :
	rm -f version
#	make -C deb clean
