# sanity checks
if [ ! -d obj-x86_64-pc-mingw32/dist ]; then exit 1; fi

# apply the LibreWolf settings
cp -rv ../settings/* obj-x86_64-pc-mingw32/dist/librewolf
    
# recreate the zip file..
cd obj-x86_64-pc-mingw32/dist
 # clean garbage files
 rm -vrf librewolf/uninstall librewolf/maintenanceservice* librewolf/pingsender.exe
 # be sure to remove the previous zip file..
 rm -vf librewolf-$pkgver.en-US.win64.txt librewolf-$pkgver.en-US.win64.zip
 zip -r9 librewolf-$pkgver.en-US.win64.zip librewolf
 if [ $? -ne 0 ]; then exit 1; fi
 sha256sum.exe librewolf-$pkgver.en-US.win64.zip > librewolf-$pkgver.en-US.win64.zip.sha256sum
 if [ $? -ne 0 ]; then exit 1; fi
 # copy the resulting zip file
 rm -vf ../../../librewolf-$pkgver.en-US.win64.zip*
 cp -v librewolf-$pkgver.en-US.win64.zip* ../../..
cd ../..




# generate the .nsi intaller file.
cat >../installer_win.nsi <<END
#
# Change these values to fit your application...
#

!define APPNAME "LibreWolf"       # Full app name, like: "Gtk+ 2.0 Hello World"
!define PROGNAME "librewolf"      # executable name, like: gtk2hello
!define PROG_VERSION "${pkgver}"     # the program version, like: 0.3.0
!define ICON_NAME "librewolf.ico" # filename of icon to use for this app
!define COMPANYNAME "LibreWolf"   # Your name, or company (or just the program name)
!define ESTIMATED_SIZE 190000     # Estimated size (in KB) of installed program for use in "add or remove programs" / 190 MB

#
# The actual installer/uninstaller, you should not need to change much here below
#

Name "\${PROGNAME}"
OutFile "\${PROGNAME}-\${PROG_VERSION}.en-US.win64-setup.exe"
InstallDir \$PROGRAMFILES64\\\${APPNAME}
RequestExecutionLevel admin

Page directory
Page instfiles

function .onInit
	setShellVarContext all
functionEnd
 
Section "\${PROGNAME}"

	# Copy files
	SetOutPath \$INSTDIR
	File /r librewolf\*.*

	# Start Menu
	createDirectory "\$SMPROGRAMS\\\${COMPANYNAME}"
	createShortCut "\$SMPROGRAMS\\\${COMPANYNAME}\\\${APPNAME}.lnk" "\$INSTDIR\\\${PROGNAME}.exe" "" "\$INSTDIR\\\${ICON_NAME}"

	# Uninstaller 
	writeUninstaller "\$INSTDIR\uninstall.exe"

	# Registry information for add/remove programs
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\\${COMPANYNAME} \${APPNAME}" "DisplayName" "\${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\\${COMPANYNAME} \${APPNAME}" "UninstallString" "\$\\"\$INSTDIR\uninstall.exe\$\\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\\${COMPANYNAME} \${APPNAME}" "QuietUninstallString" "\$\\"\$INSTDIR\uninstall.exe\$\\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\\${COMPANYNAME} \${APPNAME}" "InstallLocation" "\$\\"\$INSTDIR\$\\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\\${COMPANYNAME} \${APPNAME}" "DisplayIcon" "\$\\"\$INSTDIR\\\${ICON_NAME}$\\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\\${COMPANYNAME} \${APPNAME}" "Publisher" "\${COMPANYNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\\${COMPANYNAME} \${APPNAME}" "DisplayVersion" "\${PROG_VERSION}"
	# There is no option for modifying or repairing the install
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\\${COMPANYNAME} \${APPNAME}" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\\${COMPANYNAME} \${APPNAME}" "NoRepair" 1
	# Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\\${COMPANYNAME} \${APPNAME}" "EstimatedSize" \${ESTIMATED_SIZE}

SectionEnd

# Before uninstall, ask for confirmation
function un.onInit
	SetShellVarContext all
 
	#Verify the uninstaller - last chance to back out
	MessageBox MB_OKCANCEL "Permanantly remove \${APPNAME}?" IDOK next
		Abort
	next:
functionEnd

# Uninstaller
section "uninstall"

	# Remove Start Menu launcher
	delete "\$SMPROGRAMS\\\${COMPANYNAME}\\\${APPNAME}.lnk"
	# Try to remove the Start Menu folder - this will only happen if it is empty
	rmDir "\$SMPROGRAMS\\\${COMPANYNAME}"
 
	# Remove files
	rmDir /r \$INSTDIR

	# Remove uninstaller information from the registry
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\\\${COMPANYNAME} \${APPNAME}"

sectionEnd
END






# now to try to make the installer.
pushd ..
 rm -vrf librewolf
 unzip librewolf-$pkgver.en-US.win64.zip
 if [ $? -ne 0 ]; then exit 1; fi
 cp -v common/source_files/browser/branding/librewolf/firefox.ico librewolf/librewolf.ico
 makensis-3.01.exe installer_win.nsi
 if [ $? -ne 0 ]; then exit 1; fi
 sha256sum.exe librewolf-$pkgver.en-US.win64-setup.exe > librewolf-$pkgver.en-US.win64-setup.exe.sha256sum
 if [ $? -ne 0 ]; then exit 1; fi
popd
