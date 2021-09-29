.phony: all clean veryclean  fetch extract lw_do_patches build lw_post_build package lw_artifacts

BUILD=python3 build.py ${OPTS}


all :
	$(BUILD) all
clean :
	$(BUILD) clean
	make -C docker clean

veryclean :
	$(BUILD) veryclean

fetch :
	$(BUILD) fetch
extract :
	$(BUILD) extract
do_patches lw_do_patches :
	$(BUILD) lw_do_patches
build :
	$(BUILD) build
post_build lw_post_build :
	$(BUILD) lw_post_build
package :
	$(BUILD) package
artifacts lw_artifacts :
	$(BUILD) lw_artifacts

update update_submodules :
	$(BUILD) update_submodules
upload :
	$(BUILD) upload
git_init :
	$(BUILD) git_init
reset :
	$(BUILD) reset



# Building docker files..
.phony : docker-all docker-clean
docker-all :
	make -C docker all
docker-clean :
	make -C docker clean
