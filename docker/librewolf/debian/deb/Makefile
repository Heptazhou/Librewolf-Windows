docker_stage = deb-debian

all : cache

cache :
	sudo docker build -t librewolf/$(docker_stage) .
	make get_zip

no-cache :
	sudo docker build --no-cache -t librewolf/$(docker_stage) .
	make get_zip

get_zip : artifacts/librewolf-92.0.1.en-US.debian.zip

artifacts/librewolf-92.0.1.en-US.debian.zip : 
	sudo docker create --name extract0 librewolf/$(docker_stage)
	sudo rm -rf artifacts
	sudo docker cp extract0:/artifacts .
	sudo docker rm extract0
	sudo mv -v artifacts/librewolf-92.0.1.en-US.deb.zip artifacts/librewolf-92.0.1.en-US.debian.zip 
	sudo chown user:user artifacts/librewolf-92.0.1.en-US.debian.zip 
