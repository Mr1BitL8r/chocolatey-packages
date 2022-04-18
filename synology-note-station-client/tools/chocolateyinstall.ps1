$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://global.download.synology.com/download/Utility/NoteStationClient/123/Windows/i686/synology-note-station-client-123-win-x86-Setup.exe'
$url64      = 'https://global.download.synology.com/download/Utility/NoteStationClient/123/Windows/x86_64/synology-note-station-client-123-win-x64-Setup.exe'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Synology Note Station Client*'

  checksum      = '123'
  checksumType  = 'md5'
  checksum64    = '123'
  checksumType64= 'md5'

  silentArgs   = '/S'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
