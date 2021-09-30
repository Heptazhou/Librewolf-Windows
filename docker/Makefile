help :
	@echo "Use: make all clean lw prune mozilla full"
	@echo "     make debian fedora mint ubuntu"

all : lw
# for working with the original mozilla source:
# all : mozilla

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

full : prune lw mozilla



debian :
	make -C buildenv/debian
	make -C librewolf/debian
fedora :
	mace -C buildenv/fedora
	make -C librewolf/fedora
mint :
	mace -C buildenv/mint
	make -C librewolf/mint
ubuntu :
	mace -C buildenv/ubuntu
	make -C librewolf/ubuntu

