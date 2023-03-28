﻿$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
rm $toolsDir\yed-* -Recurse -ea 0

$packageArgs = @{
  packageName    = 'yed'
  url            = 'https://www.yworks.com/resources/yed/demo/yEd-3.23.1.zip'
  url64bit       = 'https://www.yworks.com/resources/yed/demo/yEd-3.23.1.zip'
  checksum       = 'd9a036962db9e958ad589a11d67f35e28236eabc0793b3f265559690187e34bd'
  checksum64     = 'd9a036962db9e958ad589a11d67f35e28236eabc0793b3f265559690187e34bd'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs
$yedDir = gi $toolsDir\yed-* | sort CreationTime -Descending | select -First 1 -Expand Fullname

Update-SessionEnvironment   #java might be installed
$javaw_path = gcm javaw | % { $_.Path }
if (!$javaw_path) { throw "javaw is not on the PATH" }

$cmdPath = "$toolsDir\yed.cmd"
"start javaw -jar ""$yedDir\yed.jar"" %1" | out-file $cmdPath -Encoding ascii
#Install-BinFile yed $cmdPath

# Shortcut parameters
$sparams = @{
    ShortcutFilePath = "$toolsDir\yed.lnk"
    TargetPath       = $javaw_path
    Arguments        = "-jar ""$yedDir\yed.jar"""
    IconLocation     = "$yedDir\icons\yed.ico"
}
Install-ChocolateyShortcut @sparams

Register-Application "$toolsDir\yed.lnk" yed
Write-Host "Application registered as yed"

$pp = Get-PackageParameters
if ( !$pp.NoShortcut ) {
    Write-Host "Creating desktop shortcut"
    $sparams.ShortcutFilePath = "$Env:USERPROFILE\Desktop\yed.lnk"
    Install-ChocolateyShortcut @sparams
}

if ( !$pp.NoStartMenu ) {
    Write-Host "Creating Start menu shortcut"
    $sparams.ShortcutFilePath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\yed.lnk"
    Install-ChocolateyShortcut @sparams
}

if ( $pp.Associate ) {
    ".graphml", ".graphmlz", ".ygf", ".gml", ".xgml", ".tgf", ".ged" | % {
        "Associating $_"
        Install-ChocolateyFileAssociation -Extension $_ -Executable $cmdPath
    }
}
