.PHONY : help all clean veryclean fetch build artifacts update full-mar serve-mar langpacks

help :
	@echo "Use: make [all] [clean] [veryclean] [check] ..."
	@echo ""
	@echo "  all       - Build librewolf and it's windows artifacts."
	@echo "  clean     - Remove output files and temporary files."
	@echo "  veryclean - Like 'clean', but also remove all downloaded files."
	@echo "  update    - update 'version' and 'source_release' files."
	@echo "  full-mar  - create mar setup file, and update.xml."
	@echo "  serve-mar - serve the update files"
	@echo "  langpacks - build language packs."
	@echo ""
	@echo "  fetch     - Fetch the latest librewolf source."
	@echo "  build     - Perform './mach build && ./mach package' on it."
	@echo "  debug     - Perform a debug build with different 'mozconfig'."
	@echo "  artifacts - Create the setup.exe and the portable.zip."
	@echo ""
	@echo "Note: to upload, after artifacts, into the windows repo, use:"
	@echo ""
	@echo " python3 mk.py upload <token>"
	@echo ""

all : fetch build artifacts

clean :
	cp version source_release linux && cp version source_release linux-mar
	$(MAKE) -C linux clean && $(MAKE) -C linux-mar clean
	rm -rf work

veryclean : clean
	cp version source_release linux && cp version source_release linux-mar
	$(MAKE) -C linux veryclean && $(MAKE) -C linux-mar veryclean
	rm -f librewolf-$(shell cat version)*.en-US.win64* sha256sums.txt upload.txt firefox-$(shell cat version)*.en-US.win64.zip firefox-$(shell cat version)*.en-US.win64.installer.exe
	rm -rf librewolf-$(shell cat version)-$(shell cat source_release)
	rm -f librewolf-$(shell cat version)-*.source.tar.gz*

update :
	@echo "Fetching from gitlab.."
	@wget -q -O version "https://gitlab.com/librewolf-community/browser/source/-/raw/main/version"
	@wget -q -O source_release "https://gitlab.com/librewolf-community/browser/source/-/raw/main/release"
	@echo ""
	@echo Version: $(shell cat version)-$(shell cat source_release)
	@echo Windows release version: $(shell cat release)

fetch : 
	python3 mk.py fetch

build :
	python3 mk.py build

debug :
	python3 mk.py build-debug

artifacts : langpacks
	python3 mk.py artifacts

full-mar :
	python3 mk.py full-mar

serve-mar :
	(cd librewolf-$(shell cat version)-$(shell cat source_release)/MAR && python3 -m http.server 8000)

langpacks :
	(cd librewolf-$(shell cat version)-$(shell cat source_release) && cat browser/locales/shipped-locales | xargs ./mach package-multi-locale --locales)
