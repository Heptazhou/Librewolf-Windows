all :
	cp version librewolf
	make debian10 debian11 fedora34 mint20 ubuntu20 windows

help :
	@echo "Use: make all clean lw prune mozilla full"
	@echo "     make debian10 debian11 fedora34 mint20 ubuntu20"
	@echo "     make low-disk-full-build upload-logs"

clean :
	rm -f librewolf/version release/version
	make -C librewolf clean
	make -C release clean

veryclean : clean
	rm -f *.log

mozilla :
	cp version release
	make -C buildenv
	make -C nightly
	make -C release


###


debian10 :
	script -O ubuntu20.build.env.log -c "time make -C buildenv/debian10"
	cp version librewolf && cp version librewolf/debian10
	script -O ubuntu20.build.app.log -c "time make -C librewolf/debian10"

debian11 :
	script -O ubuntu20.build.env.log -c "time make -C buildenv/debian11"
	cp version librewolf && cp version librewolf/debian11
	script -O ubuntu20.build.app.log -c "time make -C librewolf/debian11"

fedora34 :
	script -O ubuntu20.build.env.log -c "time make -C buildenv/fedora34"
	cp version librewolf && cp version librewolf/fedora34
	script -O ubuntu20.build.app.log -c "time make -C librewolf/fedora34"

mint20 :
	script -O ubuntu20.build.env.log -c "time make -C buildenv/mint20"
	cp version librewolf && cp version librewolf/mint20
	script -O ubuntu20.build.app.log -c "time make -C librewolf/mint20"

ubuntu20 :
	script -O ubuntu20.build.env.log -c "time make -C buildenv/ubuntu20"
	cp version librewolf && cp version librewolf/ubuntu20
	script -O ubuntu20.build.app.log -c "time make -C librewolf/ubuntu20"

windows :
	script -O windows.build.env.log -c "time make -C buildenv/windows"
	cp version librewolf && cp version librewolf/windows
	script -O windows.build.app.log -c "time make -C librewolf/windows"




low-disk-full-build :
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
	make windows
	make prune

upload-logs :
	scp *.log vps:pub/pub/librewolf/buildlogs

prune :
	sudo docker system prune --all --force
