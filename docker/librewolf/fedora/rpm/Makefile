distro = fedora
extractor = extract1
docker_stage = rpm-$(distro)
version = `cat ../version`


all : cache

cache :
	sudo docker build -t librewolf/$(docker_stage) .
	make get_zip

no-cache :
	sudo docker build --no-cache -t librewolf/$(docker_stage) .
	make get_zip

get_zip : artifacts/librewolf-$(version).en-US.$(distro).zip

artifacts/librewolf-$(version).en-US.$(distro).zip : 
	sudo docker create --name $(extractor) librewolf/$(docker_stage)
	sudo rm -rf artifacts
	sudo docker cp $(extractor):/artifacts .
	sudo docker rm $(extractor)
	sudo mv -v artifacts/librewolf-$(version).en-US.deb.zip artifacts/librewolf-$(version).en-US.$(distro).zip 
	sudo chown user:user artifacts/librewolf-$(version).en-US.$(distro).zip 
