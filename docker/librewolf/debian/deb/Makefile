docker_stage = deb-debian

all :
	sudo docker build -t librewolf/$(docker_stage) .

no-cache :
	sudo docker build --no-cache -t librewolf/$(docker_stage) .

