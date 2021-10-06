distro = fedora34
extractor = extract12
docker_stage = rpm-$(distro)
version = `cat ../version`


all : cache

clean :
	sudo rm -f build_tag artifacts/build_tag

cache :
	sudo docker build -t librewolf/$(docker_stage) .
	make get_zip

no-cache :
	sudo docker build --no-cache -t librewolf/$(docker_stage) .
	make get_zip

dist : clean get_zip

get_zip : build_tag

build_tag : artifacts/build_tag
	cp -v artifacts/build_tag build_tag

artifacts/build_tag :
	sudo docker create --name $(extractor) librewolf/$(docker_stage)
	sudo rm -rf artifacts
	sudo docker cp $(extractor):/artifacts .
	sudo docker rm $(extractor)
	sudo mv -v artifacts/librewolf-$(version).en-US.rpm.zip artifacts/librewolf-$(version).en-US.$(distro).zip 
	sudo chown user:user artifacts/librewolf-$(version).en-US.$(distro).zip 
	sudo chown user:user artifacts/librewolf-$(version)*.rpm
	scp artifacts/librewolf-$(version)*.rpm vps:pub/pub/librewolf

