#
# Change these values to fit your application...
#

!define APPNAME "LibreWolf"        # Full app name, like: "Gtk+ 2.0 Hello World"
!define PROGNAME "librewolf"       # executable name, like: gtk2hello
!define PROG_VERSION "pkg_version" # the program version, like: 0.3.0
!define ICON_NAME "librewolf.ico"  # filename of icon to use for this app
!define COMPANYNAME "LibreWolf"    # Your name, or company (or just the program name)
!define ESTIMATED_SIZE 190000      # Estimated size (in KB) of installed program for use in "add or remove programs" / 190 MB

#
# The actual installer/uninstaller, you should not need to change much here below
#

Name "${PROGNAME}"
OutFile "${PROGNAME}-${PROG_VERSION}.en-US.win64-setup.exe"
InstallDir $PROGRAMFILES64\${APPNAME}
RequestExecutionLevel admin

Page directory
Page instfiles

function .onInit
	setShellVarContext all
functionEnd
 
Section "${PROGNAME}"

	# Copy files
	SetOutPath $INSTDIR
	File /r librewolf\*.*

	# Start Menu
	createDirectory "$SMPROGRAMS\${COMPANYNAME}"
	createShortCut "$SMPROGRAMS\${COMPANYNAME}\${APPNAME}.lnk" "$INSTDIR\${PROGNAME}.exe" "" "$INSTDIR\${ICON_NAME}"
	createShortCut "$SMPROGRAMS\${COMPANYNAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" ""

	# Uninstaller 
	writeUninstaller "$INSTDIR\uninstall.exe"

	# Registry information for add/remove programs
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayIcon" "$\"$INSTDIR\${ICON_NAME}$\""
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
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities" "ApplicationIcon" "C:\Program Files\LibreWolf\librewolf.exe,0"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities" "ApplicationName" "LibreWolf"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities\FileAssociations" ".htm" "LibreWolfHTM"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities\FileAssociations" ".html" "LibreWolfHTM"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities\Startmenu" "StartMenuInternet" "LibreWolf"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities\URLAssociations" "http" "LibreWolfHTM"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\Capabilities\URLAssociations" "https" "LibreWolfHTM"

	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\DefaultIcon" "" "C:\Program Files\LibreWolf\librewolf.exe,0"
	WriteRegStr HKLM "Software\Clients\StartMenuInternet\LibreWolf\shell\open\command" "" "C:\Program Files\LibreWolf\librewolf.exe"
	
	WriteRegStr HKLM "Software\RegisteredApplications" "LibreWolf" "Software\Clients\StartMenuInternet\LibreWolf\Capabilities"
	
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM" "" "LibreWolf Handler"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM" "AppUserModelId" "LibreWolf"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\Application" "AppUserModelId" "LibreWolf"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\Application" "ApplicationIcon" "C:\Program Files\LibreWolf\librewolf.exe,0"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\Application" "ApplicationName" "LibreWolf"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\Application" "ApplicationDescription" "Howling to Freedom"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\Application" "ApplicationCompany" "LibreWolf"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\DefaultIcon" "" "C:\Program Files\LibreWolf\librewolf.exe,0"
	WriteRegStr HKLM "Software\Classes\LibreWolfHTM\shell\open\command" "" "C:\Program Files\LibreWolf\librewolf.exe %1"

SectionEnd

# Before uninstall, ask for confirmation
function un.onInit
	SetShellVarContext all
 
	#Verify the uninstaller - last chance to back out
	MessageBox MB_OKCANCEL "Permanantly remove ${APPNAME}?" IDOK next
		Abort
	next:
functionEnd

# Uninstaller
section "uninstall"

	# Remove Start Menu launcher
	delete "$SMPROGRAMS\${COMPANYNAME}\${APPNAME}.lnk"
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
