all : lw

help :
	@echo "Use: make all clean lw prune mozilla full"
	@echo "     make debian fedora mint ubuntu"

clean :
	rm -f librewolf/version release/version

	make -C librewolf clean
	make -C release clean

lw :
	cp version librewolf

	make -C buildenv
	make -C librewolf

mozilla :
	cp version release

	make -C buildenv
	make -C nightly
	make -C release

prune :
	sudo docker system prune --all --force

madman : prune lw mozilla



debian11 :
	make -C buildenv/debian11
	cp version librewolf/debian11
	make -C librewolf/debian11
fedora :
	make -C buildenv/fedora
	cp version librewolf/fedora
	make -C librewolf/fedora
mint :
	make -C buildenv/mint
	cp version librewolf/mint
	make -C librewolf/mint
ubuntu :
	make -C buildenv/ubuntu
	cp version librewolf/ubuntu
	make -C librewolf/ubuntu

low_disk :
	cp version librewolf

	make prune
	make debian
	make prune
	make fedora
	make prune
	make mint
	make prunt
	make ubuntu
	make prune
