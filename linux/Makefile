.PHONY : help fetch all clean build artifacts dir bootstrap winsdk setup-debian setup-fedora veryclean

version:=$(shell cat version)
release:=$(shell cat release)
source_release:=$(shell cat source_release)
full_version:=$(version)-$(source_release)$(shell [ $(release) -gt 1 ] && echo "-$(release)")
mozbuild=~/.mozbuild

help :

	@echo "use: make [help] [all] [clean] [build] [package] [artifacts]"
	@echo ""
	@echo "  fetch     - get the latest tarball. must be done first, at least once."
	@echo ""
	@echo "  all       - Build librewolf and it's windows artifacts."
	@echo "  build     - Perform './mach build' on the extracted tarball."
	@echo "  package   - multilocale package."
	@echo "  artifacts - Create the setup.exe and the portable.zip."
	@echo ""
	@echo "  clean     - Remove output files and temporary files."
	@echo "  veryclean - Remove even more stuff."
	@echo "  dir       - just extract and patch the LW tarball."
	@echo "  bootstrap - try to set up the build environment."
	@echo "  setup-debian, setup-fedora - needed packages."
	@echo ""

all : build package artifacts

fetch :
	wget -q -O version "https://gitlab.com/librewolf-community/browser/source/-/raw/main/version"
	wget -q -O source_release "https://gitlab.com/librewolf-community/browser/source/-/raw/main/release"
	wget -q -O "librewolf-$$(cat version)-$$(cat source_release).source.tar.gz.sha256sum" "https://gitlab.com/librewolf-community/browser/source/-/jobs/artifacts/main/raw/librewolf-$$(cat version)-$$(cat source_release).source.tar.gz.sha256sum?job=Build"
	wget -q -O "librewolf-$$(cat version)-$$(cat source_release).source.tar.gz" "https://gitlab.com/librewolf-community/browser/source/-/jobs/artifacts/main/raw/librewolf-$$(cat version)-$$(cat source_release).source.tar.gz?job=Build"
	cat "librewolf-$$(cat version)-$$(cat source_release).source.tar.gz.sha256sum"
	sha256sum -c "librewolf-$$(cat version)-$$(cat source_release).source.tar.gz.sha256sum"

clean :
	rm -rf librewolf-$(full_version) work

veryclean : clean
	rm -rf firefox-$(full_version).en-US.win64.zip librewolf-$(full_version).en-US.win64-setup.exe librewolf-$(full_version).en-US.win64-portable.zip
	rm -f "librewolf-$$(cat version)-$$(cat source_release).source.tar.gz" "librewolf-$$(cat version)-$$(cat source_release).source.tar.gz.sha256sum"
	rm -f version source_release

build : dir
	(cd librewolf-$(full_version) && ./mach build)

package : dir
#	(cd librewolf-$(full_version) && ./mach package)
	( cd librewolf-$(full_version) && echo 'Packaging... (output hidden)' && \
	  cat browser/locales/shipped-locales | xargs ./mach package-multi-locale --locales >/dev/null )

dir : librewolf-$(full_version)
librewolf-$(full_version) : librewolf-$(full_version).source.tar.gz
	rm -rf $@
	tar xf $<
	cp -v assets/mozconfig librewolf-$(full_version)
	(cd librewolf-$(full_version) && patch -p1 -i ../assets/tryfix-reslink-fail.patch)
	(cd librewolf-$(full_version) && patch -p1 -i ../assets/fix-l10n-package-cmd.patch)

winsdk : $(mozbuild)/vs.tar.zst
	(mkdir -p $(mozbuild)/win-cross && cd $(mozbuild)/win-cross && rm -rf vs && tar xf ../vs.tar.zst)
$(mozbuild)/vs.tar.zst : # cache this file
	(cd librewolf-$(full_version) && ./mach --no-interactive python --virtualenv build build/vs/pack_vs.py build/vs/vs2019.yaml -o $(mozbuild)/vs.tar.zst)

bootstrap : dir winsdk
	(cd librewolf-$(full_version) && ./mach --no-interactive bootstrap --application-choice=browser)
	~/.cargo/bin/rustup target add x86_64-pc-windows-msvc
	( export t=$$(pwd)/librewolf-$(full_version) && \
	  cd $(mozbuild) && \
	  $$t/mach artifact toolchain --from-build linux64-binutils && \
	  $$t/mach artifact toolchain --from-build linux64-cbindgen && \
	  $$t/mach artifact toolchain --from-build linux64-clang && \
	  $$t/mach artifact toolchain --from-build linux64-dump_syms && \
	  $$t/mach artifact toolchain --from-build linux64-liblowercase && \
	  $$t/mach artifact toolchain --from-build linux64-nasm && \
	  $$t/mach artifact toolchain --from-build linux64-node && \
	  $$t/mach artifact toolchain --from-build linux64-rust-cross && \
	  $$t/mach artifact toolchain --from-build linux64-winchecksec && \
	  $$t/mach artifact toolchain --from-build linux64-wine && \
	  $$t/mach artifact toolchain --from-build nsis && \
	  $$t/mach artifact toolchain --from-build sysroot-x86_64-linux-gnu && \
	  true )

setup-debian :
	apt-get -y install mercurial python3 python3-dev python3-pip curl wget dpkg-sig msitools p7zip-full upx-ucl libssl-dev zstd wine

setup-fedora :
	dnf -y install python3 curl wget zstd python3-devel python3-pip mercurial msitools p7zip upx openssl-devel wine

#
# Build the artifacts in a seperate Makefile
#

firefox-$(full_version).en-US.win64.zip : # build stage output artifact
	cp -v librewolf-$(full_version)/obj-x86_64-pc-mingw32/dist/firefox-$(version)-$(source_release).en-US.win64.zip .
artifacts : firefox-$(full_version).en-US.win64.zip
	${MAKE} -f assets/artifacts.mk artifacts

