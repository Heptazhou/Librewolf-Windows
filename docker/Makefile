all : lw

help :
	@echo "Use: make all clean lw prune mozilla full"
	@echo "     make debian10 debian11 fedora34 mint20 ubuntu20"

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



debian10 :
	make -C buildenv/debian10
	cp version librewolf/debian10
	make -C librewolf/debian10
debian11 :
	make -C buildenv/debian11
	cp version librewolf/debian11
	make -C librewolf/debian11
fedora34 :
	make -C buildenv/fedora34
	cp version librewolf/fedora34
	make -C librewolf/fedora34
mint20 :
	make -C buildenv/mint20
	cp version librewolf/mint20
	make -C librewolf/mint20
ubuntu20 :
	make -C buildenv/ubuntu20
	cp version librewolf/ubuntu20
	make -C librewolf/ubuntu20

low_disk :
	cp version librewolf

	make prune
	make debian10
	make prune
	make debian11
	make prune
	make fedora34
	make prune
	make mint20
	make prunt
	make ubuntu20
	make prune
