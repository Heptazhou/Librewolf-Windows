all :
	cp version release && cp version librewolf && cp version fetched-image

	make -C buildenv
	make -C fetched-image
	make -C librewolf

clean :
	rm -f librewolf/version release/version fetched-image/version

	make -C librewolf clean
	make -C release clean

prune :
	sudo docker system prune --all --force

mozilla :
	cp version release && cp version librewolf && cp version fetched-image

	make -C buildenv
	make -C fetched-image
	make -C nightly
	make -C release
