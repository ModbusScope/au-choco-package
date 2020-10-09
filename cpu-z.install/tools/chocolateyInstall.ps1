﻿$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = 'cpu-z.install'
  fileType       = 'exe'
  url            = 'http://download.cpuid.com/cpu-z/cpu-z_1.94-en.exe'
  url64bit       = 'http://download.cpuid.com/cpu-z/cpu-z_1.94-en.exe'
  checksum       = '791e1169bbdbf15d8b8741da53f45103e2dc24b95a54c2b37e2bcae82a65ff60'
  checksum64     = '791e1169bbdbf15d8b8741da53f45103e2dc24b95a54c2b37e2bcae82a65ff60'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART'
  validExitCodes = @(0)
  softwareName   = 'cpu-z'
}
Install-ChocolateyPackage @packageArgs

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageArgs.softwareName
if ($installLocation)  {
    Write-Host "$packageName installed to '$installLocation'"
    Register-Application "$installLocation\cpuz.exe"
    Write-Host "$packageName registered as cpuz"
}
else { Write-Warning "Can't find $packageName install location" }
