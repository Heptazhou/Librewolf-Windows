docker_stage = deb-mint

all : cache

cache :
	sudo docker build -t librewolf/$(docker_stage) .
	make get_zip

no-cache :
	sudo docker build --no-cache -t librewolf/$(docker_stage) .
	make get_zip

get_zip : artifacts/librewolf-92.0.1.en-US.mint.zip

artifacts/librewolf-92.0.1.en-US.mint.zip : 
	sudo docker create --name extract2 librewolf/$(docker_stage)
	sudo rm -rf artifacts
	sudo docker cp extract2:/artifacts .
	sudo docker rm extract2
	sudo mv -v artifacts/librewolf-92.0.1.en-US.deb.zip artifacts/librewolf-92.0.1.en-US.mint.zip 
	sudo chown user:user artifacts/librewolf-92.0.1.en-US.mint.zip 
