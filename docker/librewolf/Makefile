all :
	cp version debian/version && cp version fedora/version && cp version ubuntu/version && cp version mint/version
	make -C debian
	make -C fedora
	make -C ubuntu
	make -C mint

clean :
	sudo docker image prune --force


