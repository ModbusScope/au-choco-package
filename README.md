This repository contains [chocolatey automatic packages](https://chocolatey.org/docs/automatic-packages) for ModbusScope. It is forked and adapted from https://github.com/majkinetor/au-packages. And further adapted to [chocolatey-au](https://github.com/chocolatey-community/chocolatey-au)

## Prerequisites

To run locally you will need:

- Powershell 5+.
- [Chocolatey Automatic Package Updater Module](https://github.com/chocolatey-community/chocolatey-au): `choco install chocolatey-au --confirm`.

## Automatic package update

Run from within the directory of the package to update that package

    cd modbusscope

### Automatic

* Run `update.ps1`
* Push package to repository
  * `choco push modbusscope.x.x.x.nupkg --source https://push.chocolatey.org/`

#### Force update

Set `$au_Force = $true` prior to script call to update the package even if no new version is found.

### Manual

* Generate checksum
  * `checksum -t sh256 ModbusScope_Setup.exe`
* Generate package
  * `choco pack`
* Install local `nupkg` file

  * `choco install ModbusScope --source .`

  * or more chatty:
    * `choco install ModbusScope --debug --verbose --source .`
* Images:
  * Don't use Github as hosting
  * Use https://raw.githack.com/