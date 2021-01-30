# delete old things...
Remove-Item -Path firefox.exe -Force
Remove-Item -Path librewolf -Force


# windows download version lastest win64
$url = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64"

# windows download version lastest win32
#$url = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win"

$downloadfile = "$PSScriptRoot\firefox.exe"

Write-Output "Downloading to $downloadfile"

# download firefox
Invoke-WebRequest -Uri $url -outfile $downloadfile

Write-Output "Extracting $downloadfile to librewolf"
# extract with 7zip
& "$PSScriptRoot\7za.exe" x -olibrewolf .\firefox.exe

Write-Output "Delete files with privacy....."
# remove contact with mothership
Remove-Item -Path librewolf\core\crashreporter.exe -Force
Remove-Item -Path librewolf\core\updater.exe -Force
Remove-Item -Path librewolf\core\pingsender.exe -Force

Write-Output "Copy librewolf settings"
Copy-Item  -Path "$PSScriptRoot\settings\*" -Destination "$PSScriptRoot\librewolf\core" -Recurse -force