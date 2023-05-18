This repository contains [chocolatey automatic packages](https://chocolatey.org/docs/automatic-packages) for ModbusScope. It is forked and adapted from https://github.com/majkinetor/au-packages

## Prerequisites

To run locally you will need:

- Powershell 5+.
- [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au): `Install-Module au` or `cinst au`.

## Automatic package update

### Single package

Run from within the directory of the package to update that package:

    cd <package_dir>
    ./update.ps1

Set `$au_Force = $true` prior to script call to update the package even if no new version is found.
