﻿$ErrorActionPreference = "Stop"

$pp = Get-PackageParameters
if(!$pp.Password) {
    $pp.Password = [guid]::NewGuid().ToString("N")
    Write-Warning "You did not specify a password for the postgres user so an insecure one has been generated for you. Please change it immediately."
    Write-Warning "Generated password: $($pp.Password)"
}

$silentArgs = @{
    Mode                = "unattended"
    UnattendedModeUI    = "none"
    SuperPassword       = $pp.Password
    Enable_ACLedit      = 1
    Install_Runtimes    = 0
}
if ($pp.Port) { Write-Host "Using port: $($pp.Port)"; $silentArgs.ServerPort = $pp.Port }

$packageArgs = @{
    packageName     = $Env:ChocolateyPackageName
    fileType        = 'exe'
    url64           = 'https://get.enterprisedb.com/postgresql/postgresql-15.2-1-windows-x64.exe'
    checksum64      = 'BE866F4B4FE2C6E6F66814CE487474AF64597ADABB981A9F97499EB968CEE054'
    checksumType64  = 'sha256'
    url             = ''
    checksum        = ''
    checksumType32  = 'sha256'
    silentArgs      =  ($silentArgs.Keys | % { "--{0} {1}" -f $_.Tolower(), $silentArgs.$_}) -join ' '
    validExitCodes  = @(0)
    softwareName    = 'PostgreSQL 15*'
}
Install-ChocolateyPackage @packageArgs
Write-Host "Installation log: $Env:TEMP\install-postgresql.log"

$installLocation = Get-AppInstallLocation $packageArgs.softwareName
if (!$installLocation)  { Write-Warning "Can't find install location"; return }
Write-Host "Installed to '$installLocation'"

if (!$pp.NoPath) { Install-ChocolateyPath "$installLocation\bin" -PathType 'Machine' }

if ($pp.AllowRemote) {
    Write-Host "Allowing remote connections"
"
# Added by Chocolatey package
host    all             all             0.0.0.0/0               md5
host    all             all             ::0/0                   md5
" | Out-File -Append "$installLocation\data\pg_hba.conf" -Encoding ascii
}
