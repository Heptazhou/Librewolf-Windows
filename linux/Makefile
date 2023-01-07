.PHONY : help fetch all clean build artifacts dir bootstrap winsdk setup-debian setup-fedora veryclean docker-build docker-run docker-clean docker-prune docker-shell buildsymbols upstream-update setup-arch bootstrap-arch bootstrap-arch-do-bootstrap old-style-bootstrap-arch old-style-bootstrap-arch-do-bootstrap build-arch build-arch-do-build extract-arch clean-arch buildsymbols-arch build-symbols-arch-do-buildsymbols package-arch package-arch-do-package patch-folder-arch winsdk-arch grab-build-artifact-arch artifacts-arch

version:=$(shell cat version)
release:=$(shell cat release)
source_release:=$(shell cat source_release)
full_version:=$(version)-$(source_release)$(shell [[ $(release) -ge 1 ]] && echo "+$(release)")
mozbuild=~/.mozbuild

docker_image_name=snowfox-win-x64

help :

	@echo "use: make [help] [all] [clean] [build] [package] [artifacts]"
	@echo ""
	@echo "  fetch     - get the latest tarball. must be done first, at least once."
	@echo ""
	@echo "  all       - Build Snowfox and its Windows artifacts."
	@echo "  build     - Perform './mach build' on the extracted tarball."
	@echo "  package   - multilocale package."
	@echo "  artifacts - Create the setup.exe and the portable.zip."
	@echo ""
	@echo "  clean     - Remove output files and temporary files."
	@echo "  veryclean - Remove even more stuff."
	@echo "  dir       - just extract and patch the Snowfox tarball."
	@echo "  bootstrap - try to set up the build environment."
	@echo "  setup-debian, setup-fedora - needed packages."
	@echo ""
	@echo "  docker-build - Run 'docker build' for" $(docker_image_name)  "image."
	@echo "  docker-run   - Run Snowfox build using 'docker run' on" $(docker_image_name)  "image."
	@echo "  docker-shell - Run shell in" $(docker_image_name)  "image, to debug why docker-run fails."
	@echo "  docker-clean - Remove" $(docker_image_name) "docker image."
	@echo "  docker-prune - Delete ALL docker data: images, containers, networks, etc."
	@echo ""
	@echo "Building natively on arch:"
	@echo "  upstream-update - Update and fetch 'version' and 'source_release'."
	@echo "  fetch-archive - Fetch the archive from the internet and verify it."
	@echo "  setup-arch - Install build dependencies."
	@echo "  extract-arch, clean-arch - Extract/remove the source tree."
	@echo "  patch-folder-arch - Patching it into a windows cross-build."
	@echo "  winsdk-arch - Extract the winsdk folder for cross-build."
	@echo ""
	@echo "  bootstrap-arch - Bootstrap the mozilla build environment."
	@echo "  old-style-bootstrap-arch - Use old style bootstrapping."
	@echo "  build-arch - Build it."
	@echo "  buildsymbols-arch - Build symbols."
	@echo "  package-arch - Package the target zip file."
	@echo "  grab-build-artifact-arch - Grab the packaged zip file into this folder"
	@echo "  artifacts-arch - build the target setup.exe and portable.zip"


all :
	${MAKE} build buildsymbols package artifacts


#
# Redo from scratch. ---
#

upstream-update :

	wget -q -O version "https://gitlab.com/librewolf-community/browser/source/-/raw/main/version"
	wget -q -O source_release "https://gitlab.com/librewolf-community/browser/source/-/raw/main/release"
	@echo "[notice] version =" "$$(cat version)"
	@echo "[notice] source_release =" "$$(cat source_release)"
	@echo "[notice] release =" "$$(cat release)"

fetch-archive :
	[ -f "version" ] && [ -f "source_release" ]
	${MAKE} fetch

arch-packages=git make gnupg python python-pip cabextract
setup-arch :
	[ -f "version" ] && [ -f "source_release" ]
	pacman -S $(arch-packages)

extract-arch :
	[ -f "version" ] && [ -f "source_release" ] && [ -f "snowfox-v$(full_version).source.tar.zst" ]
	${MAKE} clean-arch
	tar xf "snowfox-v$(full_version).source.tar.zst"

# windows-specific modifications:
patch-folder-arch :
	[ -f "version" ] && [ -f "source_release" ] && [ -d "snowfox-v$(full_version)" ]
	cp -v assets/mozconfig snowfox-v$(full_version)/mozconfig
	(cd snowfox-v$(full_version) && patch -p1 -i ../assets/fix-l10n-package-cmd.patch)

patch-folder-arch-mozconfig-new-style :
# this target is just a reminder how I would want it to work once WINE works
#	mv snowfox-v$(full_version)/mozconfig snowfox-v$(full_version)/mozconfig.std
#	cp -v assets/mozconfig.arch snowfox-v$(full_version)/mozconfig

winsdk-arch :
	${MAKE} winsdk

clean-arch :
	[ -f "version" ] && [ -f "source_release" ]
	rm -rf "snowfox-v$(full_version)"

bootstrap-arch :
	[ -f "version" ] && [ -f "source_release" ] && [ -d "snowfox-v$(full_version)" ]
	${MAKE} -C snowfox-v$(full_version) -f ../Makefile bootstrap-arch-do-bootstrap

bootstrap-arch-do-bootstrap :
	./mach --no-interactive bootstrap --application-choice=browser

# try old style bootstrapping...
old-style-bootstrap-arch :
	[ -f "version" ] && [ -f "source_release" ] && [ -d "snowfox-v$(full_version)" ]
	cp -v assets/mozconfig snowfox-v$(full_version)/mozconfig
	${MAKE} -C snowfox-v$(full_version) -f ../Makefile old-style-bootstrap-arch-do-bootstrap

old-style-bootstrap-arch-do-bootstrap :
	./mach --no-interactive bootstrap --application-choice=browser
	( export t=$$(pwd) && \
	  cd $(mozbuild) && \
	  $$t/mach artifact toolchain --from-build linux64-clang && sleep 10 && \
	  $$t/mach artifact toolchain --from-build linux64-winchecksec && sleep 10 && \
	  $$t/mach artifact toolchain --from-build linux64-wine && sleep 10 && \
	  $$t/mach artifact toolchain --from-build nsis && sleep 10 && \
	  true )

build-arch :
	[ -f "version" ] && [ -f "source_release" ] && [ -d "snowfox-v$(full_version)" ]
	${MAKE} -C snowfox-v$(full_version) -f ../Makefile build-arch-do-build
build-arch-do-build :
	./mach build
buildsymbols-arch :
	[ -f "version" ] && [ -f "source_release" ] && [ -d "snowfox-v$(full_version)" ]
	${MAKE} -C snowfox-v$(full_version) -f ../Makefile buildsymbols-arch-do-buildsymbols
buildsymbols-arch-do-buildsymbols :
	./mach buildsymbols
package-arch :
	[ -f "version" ] && [ -f "source_release" ] && [ -d "snowfox-v$(full_version)" ]
	${MAKE} -C snowfox-v$(full_version) -f ../Makefile package-arch-do-package
package-arch-do-package :
	@(echo 'Packaging... (output hidden)' && cat browser/locales/shipped-locales | xargs ./mach package-multi-locale --locales >/dev/null)
grab-build-artifact-arch :
	cp -v snowfox-v$(full_version)/obj-x86_64-pc-mingw32/dist/snowfox-$(version)-$(source_release).en-US.win64.zip .

artifacts-arch :
	${MAKE} grab-build-artifact-arch
	${MAKE} -f assets/artifacts.mk artifacts
#
# End redo ---
#

fetch :
	sha256sum -c "snowfox-v$$(cat version)-$$(cat source_release).source.tar.zst.sha256"
	rustup default stable
	rustup target add x86_64-pc-windows-msvc

clean :
	rm -rf snowfox-v$(full_version) work

veryclean : clean
	rm -rf snowfox-$(full_version).en-US.win64.zip snowfox-v$(full_version).win64.exe snowfox-v$(full_version).win64.zip
	rm -f "snowfox-v$$(cat version)-$$(cat source_release).source.tar.zst" "snowfox-v$$(cat version)-$$(cat source_release).source.tar.zst.sha256"


build : dir
	(cd snowfox-v$(full_version) && ./mach build)

buildsymbols : dir
	(cd snowfox-v$(full_version) && ./mach buildsymbols)

package : dir
#	(cd snowfox-v$(full_version) && ./mach package)
	( cd snowfox-v$(full_version) && echo 'Packaging... (output hidden)' && \
	  cat browser/locales/shipped-locales | xargs ./mach package-multi-locale --locales >/dev/null )

dir : snowfox-v$(full_version)
snowfox-v$(full_version) : snowfox-v$(full_version).source.tar.zst
	rm -rf $@
	tar xf $<
	cp -v assets/mozconfig snowfox-v$(full_version)
	(cd snowfox-v$(full_version) && patch -p1 -i ../assets/fix-l10n-package-cmd.patch)

winsdk : $(mozbuild)/vs.tar.zst
	(mkdir -p $(mozbuild)/win-cross && cd $(mozbuild)/win-cross && rm -rf vs && tar xf ../vs.tar.zst)
$(mozbuild)/vs.tar.zst : # cache this file
	(cd snowfox-v$(full_version) && ./mach --no-interactive python --virtualenv build build/vs/pack_vs.py build/vs/vs2019.yaml -o $(mozbuild)/vs.tar.zst)

bootstrap : dir winsdk
	(cd snowfox-v$(full_version) && ./mach --no-interactive bootstrap --application-choice=browser)
	( export t=$$(pwd)/snowfox-v$(full_version) && \
	  cd $(mozbuild) && \
	  $$t/mach artifact toolchain --from-build linux64-clang && sleep 10 && \
	  $$t/mach artifact toolchain --from-build linux64-winchecksec && sleep 10 && \
	  $$t/mach artifact toolchain --from-build linux64-wine && sleep 10 && \
	  $$t/mach artifact toolchain --from-build nsis && sleep 10 && \
	  true )

setup-debian :
	apt -y install mercurial python3 python3-dev python3-pip curl wget dpkg-sig msitools p7zip-full upx-ucl libssl-dev zstd wine64-tools

setup-fedora :
	dnf -y install python3 curl wget zstd python3-devel python3-pip mercurial msitools p7zip upx openssl-devel wine wine-devel

#
# Build the artifacts in a seperate Makefile
#

snowfox-$(full_version).en-US.win64.zip : # build stage output artifact
	cp -v snowfox-v$(full_version)/obj-x86_64-pc-mingw32/dist/snowfox-$(version)-$(source_release).en-US.win64.zip .
artifacts : snowfox-$(full_version).en-US.win64.zip
	${MAKE} -f assets/artifacts.mk artifacts
	rm -rf /pkg && mkdir /pkg
	cp -pt /pkg snowfox-v*.exe snowfox-v*.zip


docker-build :
	docker build -t $(docker_image_name) - < assets/Dockerfile
docker-run :
	docker run --rm $(docker_image_name) sh -c "git pull && make fetch && make build"
docker-shell :
	docker run -it --rm $(docker_image_name) /bin/bash -i
docker-clean :
	docker rmi $(docker_image_name)
docker-prune :
	docker system prune --all --force

