.PHONY: artifacts

version:=$(shell cat version)
release:=$(shell cat release)
source_release:=$(shell cat source_release)
full_version:=$(version)-$(source_release)$(shell [ $(release) -gt 1 ] && echo "-$(release)")
mozbuild=~/.mozbuild

incoming_artifact=librewolf-$(full_version).en-US.win64.installer.exe

artifacts :
	du -hs $(incoming_artifact)
