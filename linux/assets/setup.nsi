!include "MUI2.nsh"
!include "LogicLib.nsh"
!addplugindir .
!addplugindir x86-ansi

!define APPNAME "Snowfox"
!define PROGNAME "snowfox"
!define EXECUTABLE "${PROGNAME}.exe"
!define PROG_VERSION "pkg_version"
!define COMPANYNAME "Snowfox"
!define ESTIMATED_SIZE 190000
!define MUI_ICON "snowfox.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "banner.bmp"

Name "${APPNAME}"
OutFile "${PROGNAME}-${PROG_VERSION}.win64.exe"
InstallDirRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "InstallLocation"
InstallDir $PROGRAMFILES64\${APPNAME}
RequestExecutionLevel admin

# Pages

!define MUI_ABORTWARNING

!define MUI_WELCOMEPAGE_TITLE "Welcome to the Snowfox Setup"
!define MUI_WELCOMEPAGE_TEXT "This setup will guide you through the installation of Snowfox.$\r$\n$\r$\n\
If you do not have it installed already, this will also install the latest Visual C++ Redistributable.$\r$\n$\r$\n\
Click Next to continue."
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Section

	# Make sure Snowfox is closed before the installation
	nsProcess::_FindProcess "${EXECUTABLE}"
	Pop $R0
	${If} $R0 = 0
		IfSilent 0 +4
		DetailPrint "${APPNAME} is still running, aborting because of silent install."
		SetErrorlevel 2
		Abort

		DetailPrint "${APPNAME} is still running"
		MessageBox MB_OKCANCEL "Snowfox is still running and has to be closed for the setup to continue." IDOK continue IDCANCEL break
break:
		SetErrorlevel 1
		Abort
continue:
		DetailPrint "Closing ${APPNAME} gracefully..."
		nsProcess::_CloseProcess "${EXECUTABLE}"
		Pop $R0
		Sleep 2000
		nsProcess::_FindProcess "${EXECUTABLE}"
		Pop $R0
		${If} $R0 = 0
			DetailPrint "Failed to close ${APPNAME}, killing it..."
			nsProcess::_KillProcess "${EXECUTABLE}"
			Sleep 2000
			nsProcess::_FindProcess "${EXECUTABLE}"
			Pop $R0
			${If} $R0 = 0
				DetailPrint "Failed to kill ${APPNAME}, aborting"
				MessageBox MB_ICONSTOP "Snowfox is still running and cannot be closed by the installer. Please close it manually and try again."
				SetErrorlevel 2
				Abort
			${EndIf}
		${EndIf}
	${EndIf}

	# Install Visual C++ Redistributable (only if not silent)
	IfSilent +4 0
	InitPluginsDir
	File /oname=$PLUGINSDIR\vc_redist.x64.exe vc_redist.x64.exe
	ExecWait "$PLUGINSDIR\vc_redist.x64.exe /install /quiet /norestart"

	# Copy files
	SetOutPath $INSTDIR
	File /r snowfox\*.*

	# Start Menu
	createDirectory "$SMPROGRAMS\${COMPANYNAME}"
	createShortCut "$SMPROGRAMS\${COMPANYNAME}\${APPNAME}.lnk" "$INSTDIR\${PROGNAME}.exe" "" "$INSTDIR\${MUI_ICON}"
	createShortCut "$SMPROGRAMS\${COMPANYNAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" ""

	# Uninstaller
	writeUninstaller "$INSTDIR\uninstall.exe"

	# Registry information for add/remove programs
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayIcon" "$\"$INSTDIR\${MUI_ICON}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "Publisher" "${COMPANYNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayVersion" "${PROG_VERSION}"
	# There is no option for modifying or repairing the install
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoRepair" 1
	# Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "EstimatedSize" ${ESTIMATED_SIZE}


	#
	# Registry information to let Windows pick us up in the list of available browsers
	#

	WriteRegStr HKLM "Software\Clients\StartMenuInternet\Snowfox" "" "Snowfox"

	WriteRegStr HKLM "Software\Clients\StartMenuInternet\Snowfox\Capabilities" "ApplicationDescription" "Snowfox"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\Snowfox\Capabilities" "ApplicationIcon" "$INSTDIR\snowfox.exe,0"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\Snowfox\Capabilities" "ApplicationName" "Snowfox"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\Snowfox\Capabilities\FileAssociations" ".htm" "SnowfoxHTM"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\Snowfox\Capabilities\FileAssociations" ".html" "SnowfoxHTM"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\Snowfox\Capabilities\FileAssociations" ".pdf" "SnowfoxHTM"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\Snowfox\Capabilities\Startmenu" "StartMenuInternet" "Snowfox"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\Snowfox\Capabilities\URLAssociations" "http" "SnowfoxHTM"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\Snowfox\Capabilities\URLAssociations" "https" "SnowfoxHTM"

	WriteRegStr HKLM "Software\Clients\StartMenuInternet\Snowfox\DefaultIcon" "" "$INSTDIR\snowfox.exe,0"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\Snowfox\shell\open\command" "" "$INSTDIR\snowfox.exe"

	WriteRegStr HKLM "Software\RegisteredApplications" "Snowfox" "Software\Clients\StartMenuInternet\Snowfox\Capabilities"

	WriteRegStr HKLM "Software\Classes\SnowfoxHTM" "" "Snowfox Document"
	WriteRegStr HKLM "Software\Classes\SnowfoxHTM" "AppUserModelId" "Snowfox"
	WriteRegStr HKLM "Software\Classes\SnowfoxHTM\Application" "AppUserModelId" "Snowfox"
	WriteRegStr HKLM "Software\Classes\SnowfoxHTM\Application" "ApplicationIcon" "$INSTDIR\snowfox.exe,0"
	WriteRegStr HKLM "Software\Classes\SnowfoxHTM\Application" "ApplicationName" "Snowfox"
	WriteRegStr HKLM "Software\Classes\SnowfoxHTM\Application" "ApplicationDescription" "Start the Snowfox Browser"
	WriteRegStr HKLM "Software\Classes\SnowfoxHTM\Application" "ApplicationCompany" "0h7z"
	WriteRegStr HKLM "Software\Classes\SnowfoxHTM\DefaultIcon" "" "$INSTDIR\snowfox.exe,1"
	WriteRegStr HKLM "Software\Classes\SnowfoxHTM\shell\open\command" "" "$\"$INSTDIR\snowfox.exe$\" -osint -url $\"%1$\""

SectionEnd


# Uninstaller
section "Uninstall"

	# Kill Snowfox if it is still running
	nsProcess::_FindProcess "${EXECUTABLE}"
	Pop $R0
	${If} $R0 = 0
		DetailPrint "${APPNAME} is still running, killing it..."
		nsProcess::_KillProcess "${EXECUTABLE}"
		Sleep 2000
	${EndIf}

	# Remove Start Menu launcher
	delete "$SMPROGRAMS\${COMPANYNAME}\${APPNAME}.lnk"
	delete "$SMPROGRAMS\${COMPANYNAME}\Uninstall.lnk"
	# Try to remove the Start Menu folder - this will only happen if it is empty
	rmDir "$SMPROGRAMS\${COMPANYNAME}"

	# Remove files
	rmDir /r $INSTDIR

	# Remove uninstaller information from the registry
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}"

	#
	# Windows default browser integration
	#

	DeleteRegKey HKLM "Software\Clients\StartMenuInternet\Snowfox"
	DeleteRegKey HKLM "Software\RegisteredApplications"
	DeleteRegKey HKLM "Software\Classes\SnowfoxHTM"

sectionEnd
