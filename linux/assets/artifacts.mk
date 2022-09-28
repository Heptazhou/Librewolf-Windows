.PHONY: artifacts

version:=$(shell cat version)
release:=$(shell cat release)
source_release:=$(shell cat source_release)
full_version:=$(version)-$(source_release)$(shell [ $(release) -gt 1 ] && echo "-$(release)")
mozbuild=~/.mozbuild

incoming_artifact=firefox-$(full_version).en-US.win64.zip
setupname=librewolf-$(full_version).en-US.win64-setup.exe
zipname=librewolf-$(full_version).en-US.win64-portable.zip

artifacts :

# this section makes the work/librewolf folder
	( rm -rf work && mkdir work )
	( cd work && unzip -q ../$(incoming_artifact) )
	mv work/firefox work/librewolf
	mv work/librewolf/firefox.exe work/librewolf/librewolf.exe
	cp assets/librewolf.ico work/librewolf
# this section makes the setup.exe
	mkdir work/x86-ansi
	wget -q -O ./work/x86-ansi/nsProcess.dll "https://shorsh.de/upload/2y9p/nsProcess.dll"
	wget -q -O ./work/vc_redist.x64.exe "https://aka.ms/vs/17/release/vc_redist.x64.exe"
	sed "s/pkg_version/$(full_version)/g" < assets/setup.nsi > work/tmp.nsi
	cp assets/librewolf.ico work
	cp assets/banner.bmp work
	( cd work && $(mozbuild)/nsis/bin/makensis -V1 tmp.nsi )
	rm -rf work/tmp.nsi work/librewolf.ico work/banner.bmp work/x86-ansi vc_redist.x64.exe
	mv work/$(setupname) .
# this section makes the portable.zip
	rm -rf work/librewolf-$(full_version)
	mkdir -p work/librewolf-$(full_version)/Profiles/Default
	mkdir -p work/librewolf-$(full_version)/LibreWolf
	cp -r work/librewolf/* work/librewolf-$(full_version)/LibreWolf
	( cd work && git clone "https://github.com/ltGuillaume/LibreWolf-Portable" )
	cp work/LibreWolf-Portable/LibreWolf-Portable.* work/LibreWolf-Portable/*.exe work/librewolf-$(full_version)
	wget -q -O work/ahk.zip "https://www.autohotkey.com/download/ahk.zip"
	( mkdir work/ahk && cd work/ahk && unzip -q ../ahk.zip )
	( cd work/librewolf-$(full_version) && wine64 ../ahk/Compiler/Ahk2Exe.exe /in LibreWolf-Portable.ahk /icon LibreWolf-Portable.ico )
	( cd work/librewolf-$(full_version) && rm -f LibreWolf-Portable.ahk LibreWolf-Portable.ico dejsonlz4.exe jsonlz4.exe )
# issue #224 - Consider including msvcp140 & vcruntime140 in portable package	
	( cd work/librewolf-$(full_version)/LibreWolf && \
	wget -q -O ./vc_redist.x64-extracted.zip "https://gitlab.com/librewolf-community/browser/windows/uploads/7106b776dc663d985bb88eabeb4c5d7d/vc_redist.x64-extracted.zip" && \
	unzip vc_redist.x64-extracted.zip && \
	rm vc_redist.x64-extracted.zip )
	( rm -f $(zipname) && cd work && zip -qr9 ../$(zipname) librewolf-$(full_version) )