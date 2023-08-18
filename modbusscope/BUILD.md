# Choco packages (build instructions)

## Automatic

* Make sure `ua` is installed:
  * `choco install au`
* Run `update.ps1`
* Push package to repository
  * `choco push modbusscope.x.x.x.nupkg --source https://push.chocolatey.org/`

## Manual

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