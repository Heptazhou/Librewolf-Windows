.PHONY : help all clean veryclean fetch build artifact

help :
	@echo "Use: make [all] [clean] [veryclean]"
	@echo ""
	@echo "  all       - Build librewolf and it's windows artifacts."
	@echo "  clean     - Remove output files and temporary files."
	@echo "  veryclean - Like 'clean', but also remove all downloaded files."
	@echo ""
	@echo "  fetch     - Fetch the latest librewolf source."
	@echo "  build     - Perform './mach build && ./mach package' on it."
	@echo "  artifact  - Create the setup.exe and the portable.zip."
	@echo ""

all : fetch build artifact

clean :

veryclean :
	rm -f librewolf-*.source.tar.gz

fetch :
	python3 mk.py fetch

build :
	python3 mk.py build

artifact :
	python3 mk.py artifact

