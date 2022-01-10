.PHONY : help all clean veryclean fetch build artifacts

help :
	@echo "Use: make [all] [clean] [veryclean]"
	@echo ""
	@echo "  all       - Build librewolf and it's windows artifacts."
	@echo "  clean     - Remove output files and temporary files."
	@echo "  veryclean - Like 'clean', but also remove all downloaded files."
	@echo ""
	@echo "  fetch     - Fetch the latest librewolf source."
	@echo "  build     - Perform './mach build && ./mach package' on it."
	@echo "  artifacts - Create the setup.exe and the portable.zip."
	@echo ""
	@echo "Note: to upload, after artifacts, into the windows repo, use:"
	@echo ""
	@echo " python3 mk.py upload <token>"
	@echo ""

all : fetch build artifacts

clean :
	rm -rf librewolf-$(shell cat version)

veryclean :
	rm -f source_release librewolf-$(shell cat version)-*.source.tar.gz

fetch :
	python3 mk.py fetch

build :
	python3 mk.py build

artifacts :
	python3 mk.py artifacts

