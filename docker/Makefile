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

help :
	@echo "Use: make all help clean lw prune mozilla full"

