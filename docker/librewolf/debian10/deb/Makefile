distro = debian10
extractor = extract10
docker_stage = deb-$(distro)
version = `cat ../version`


all : cache

cache :
	sudo docker build -t librewolf/$(docker_stage) .
	make get_zip

no-cache :
	sudo docker build --no-cache -t librewolf/$(docker_stage) .
	make get_zip

clean :
	sudo rm -f build_tag artifacts/build_tag

get_zip : build_tag

build_tag : artifacts/build_tag
	cp -v artifacts/build_tag build_tag

artifacts/build_tag :
	sudo docker create --name $(extractor) librewolf/$(docker_stage)
	sudo rm -rf artifacts
	sudo docker cp $(extractor):/artifacts .
	sudo docker rm $(extractor)
	sudo mv -v artifacts/librewolf-$(version).en-US.deb.zip artifacts/librewolf-$(version).en-US.$(distro).zip 
	sudo mv -v artifacts/librewolf.deb artifacts/librewolf-$(version).en-US.$(distro).deb 
	sudo chown user:user artifacts/librewolf-$(version).en-US.$(distro).zip 
	sudo chown user:user artifacts/librewolf-$(version).en-US.$(distro).deb
	scp artifacts/*.deb vps:pub/pub/librewolf

