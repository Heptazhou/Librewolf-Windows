!include "MUI2.nsh"
!include "LogicLib.nsh"
!addplugindir .

!define APPNAME "LibreWolf"
!define PROGNAME "librewolf"
!define EXECUTABLE "${PROGNAME}.exe"
!define PROG_VERSION "pkg_version"
!define COMPANYNAME "LibreWolf"
!define ESTIMATED_SIZE 190000
!define MUI_ICON "librewolf.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "banner.bmp"

Name "${APPNAME}"
OutFile "${PROGNAME}-${PROG_VERSION}.en-US.win64-setup.exe"
InstallDir $PROGRAMFILES64\${APPNAME}
RequestExecutionLevel admin

# Pages

!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Section

	# Make sure LibreWolf is closed before the installation
	nsProcess::_FindProcess "${EXECUTABLE}"
	Pop $R0
	${If} $R0 = 0
		IfSilent 0 +4
		DetailPrint "${APPNAME} is still running, aborting because of silent install."
		SetErrorlevel 2
		Abort

		DetailPrint "${APPNAME} is still running. Closing it gracefully..."
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
				MessageBox MB_ICONSTOP "LibreWolf is still running and can't be closed by the installer. Please close it manually and try again."
				SetErrorlevel 2
				Abort
			${EndIf}
		${EndIf}
	${EndIf}

	# Copy files
	SetOutPath $INSTDIR
	File /r librewolf\*.*

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
	
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf" "" "LibreWolf"	

	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities" "ApplicationDescription" "LibreWolf"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities" "ApplicationIcon" "$INSTDIR\librewolf.exe,0"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities" "ApplicationName" "LibreWolf"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities\FileAssociations" ".htm" "LibreWolfHTM"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities\FileAssociations" ".html" "LibreWolfHTM"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities\FileAssociations" ".pdf" "LibreWolfHTM"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities\Startmenu" "StartMenuInternet" "LibreWolf"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities\URLAssociations" "http" "LibreWolfHTM"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities\URLAssociations" "https" "LibreWolfHTM"

	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\DefaultIcon" "" "$INSTDIR\librewolf.exe,0"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\shell\open\command" "" "$INSTDIR\librewolf.exe"
	
	WriteRegStr HKLM "Software\RegisteredApplications" "LibreWolf" "Software\Clients\StartMenuInternet\LibreWolf\Capabilities"
	
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM" "" "LibreWolf Handler"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM" "AppUserModelId" "LibreWolf"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\Application" "AppUserModelId" "LibreWolf"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\Application" "ApplicationIcon" "$INSTDIR\librewolf.exe,0"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\Application" "ApplicationName" "LibreWolf"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\Application" "ApplicationDescription" "Start the LibreWolf Browser"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\Application" "ApplicationCompany" "LibreWolf Community"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\DefaultIcon" "" "$INSTDIR\librewolf.exe,0"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\shell\open\command" "" "$INSTDIR\librewolf.exe %1"

SectionEnd


# Uninstaller
section "Uninstall"

	# Kill LibreWolf if it is still running
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
	
	DeleteRegKey HKLM "Software\Clients\StartMenuInternet\LibreWolf"
	DeleteRegKey HKLM "Software\RegisteredApplications"
	DeleteRegKey HKLM "Software\Classes\LibreWolfHTM"

sectionEnd
