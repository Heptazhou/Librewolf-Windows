docker_stage = rpm-fedora

all : cache

cache :
	sudo docker build -t librewolf/$(docker_stage) .
	make get_zip

no-cache :
	sudo docker build --no-cache -t librewolf/$(docker_stage) .
	make get_zip

no-cache :
	sudo docker build --no-cache -t librewolf/$(docker_stage) .
	make get_zip

get_zip : artifacts/librewolf-92.0.1.en-US.deb.zip

artifacts/librewolf-92.0.1.en-US.deb.zip : 
	sudo docker create --name extract1 librewolf/$(docker_stage)
	sudo rm -rf artifacts
	sudo docker cp extract1:/artifacts .
	sudo docker rm extract1
