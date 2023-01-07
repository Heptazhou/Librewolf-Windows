.PHONY: artifacts ahk-tools

version:=$(shell cat version)
release:=$(shell cat release)
source_release:=$(shell cat source_release)
full_version:=$(version)-$(source_release)$(shell [[ $(release) -ge 1 ]] && echo "+$(release)")
mozbuild=~/.mozbuild

incoming_artifact=snowfox-$(full_version).en-US.win64.zip
setupname=snowfox-v$(full_version).win64.exe
zipname=snowfox-v$(full_version).win64.zip

#wine=~/.mozbuild/wine/bin/wineconsole
wine=~/.mozbuild/wine/bin/wine64 --backend=curses




artifacts :


# this section makes the work/snowfox folder


	( rm -rf work && mkdir work )
	( cd work && unzip -q ../$(incoming_artifact) )
	rm work/snowfox/pingsender.exe
	rm work/snowfox/removed-files
	cp assets/snowfox.ico work/snowfox


# this section makes the setup.exe


	mkdir work/x86-ansi
	wget -q -O ./work/x86-ansi/nsProcess.dll "https://shorsh.de/upload/2y9p/nsProcess.dll"
	wget -q -O ./work/vc_redist.x64.exe "https://aka.ms/vs/17/release/vc_redist.x64.exe"
	sed "s/pkg_version/v$(full_version)/g" < assets/setup.nsi > work/tmp.nsi
	cp assets/snowfox.ico work
	cp assets/banner.bmp work
	( cd work && $(mozbuild)/nsis/bin/makensis -V1 tmp.nsi )
	rm -rf work/tmp.nsi work/snowfox.ico work/banner.bmp work/x86-ansi vc_redist.x64.exe
	mv work/$(setupname) .


# this section makes the portable.zip


	rm -rf work/snowfox-v$(full_version)

	mkdir -p work/snowfox-v$(full_version)/Profiles/Default
	mkdir -p work/snowfox-v$(full_version)/Snowfox

	cp -r work/snowfox/* work/snowfox-v$(full_version)/Snowfox

#


	( cd work && git clone https://github.com/Heptazhou/Snowfox-Portable )
	( cd work && cp Snowfox-Portable/*.ahk Snowfox-Portable/*.exe snowfox-v$(full_version) )
	( cd work && curl -LO https://github.com/Heptazhou/AutoHotKey/releases/latest/download/ahk.zip )
	( cd work && mkdir ahk && cd ahk && unzip -q ../ahk.zip )
	( cd work/snowfox-v$(full_version) && rm -f -r  Compiler  &&  mkdir  Compiler )
	( cd work/snowfox-v$(full_version) && cp ../ahk/Compiler/*64-bit.bin Compiler )
	( cd work/snowfox-v$(full_version) && cp ../ahk/Compiler/Ahk2Exe.exe Compiler )
	( cd work/snowfox-v$(full_version) && cp ../snowfox/snowfox.ico ./Snowfox.ico )
	( cd work/snowfox-v$(full_version) && echo -e 'lockPref("browser.privacySegmentation.createdShortcut", true)\n' \
	> Profiles/Default/snowfox.config.js )


# issue #224 - Consider including msvcp140 & vcruntime140 in portable package

	( cd work/snowfox-v$(full_version)/Snowfox && \
	wget -q -O ./vc_redist.x64-extracted.zip "https://gitlab.com/librewolf-community/browser/windows/uploads/7106b776dc663d985bb88eabeb4c5d7d/vc_redist.x64-extracted.zip" && \
	unzip vc_redist.x64-extracted.zip && \
	rm vc_redist.x64-extracted.zip )
	( rm -f $(zipname) && cd work && zip -qr9 ../$(zipname) snowfox-v$(full_version) )



ahk-tools :
# clone autohotkey stuff

	( cd work && \
	  git clone "https://github.com/Heptazhou/Snowfox-Portable"  )

	cp work/Snowfox-Portable/*.ahk work/Snowfox-Portable/*.exe work/snowfox-v$(full_version)

	wget -q -O work/ahk.zip "https://www.autohotkey.com/download/ahk.zip"
	( mkdir work/ahk && cd work/ahk && unzip -q ../ahk.zip )

# now we can use wine32 to run autohotkey
# ---
# tip from: https://forums.linuxmint.com/viewtopic.php?t=74356
	rm -rf /root/.wine
	winecfg

	-( cd work/snowfox-v$(full_version) && $(wine) ../ahk/Compiler/Ahk2Exe.exe /in Snowfox-Portable.ahk )
	[ -f work/snowfox-v$(full_version)/Snowfox-Portable.exe ] # because we ignored previous exit code
	( cd work/snowfox-v$(full_version) && rm -f Snowfox-Portable.ahk Snowfox-Portable.ico dejsonlz4.exe jsonlz4.exe )


