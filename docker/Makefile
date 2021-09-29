all :
	cp version release && cp version librewolf

	make -C buildenv
	make -C nightly
	make -C release
	make -C librewolf

clean :
	rm -f librewolf/version release/version
	make -C librewolf clean
	make -C release clean

prune :
	sudo docker system prune --all --force
