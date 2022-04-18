$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Synology Note Station Client'
  fileType      = 'EXE'
  file          = $env:UserProfile + "\AppData\Local\NoteStation\Uninstall.exe"
  silentArgs    = '/S'
  validExitCodes= @(0)
}

$uninstalled = $false

Uninstall-ChocolateyPackage @packageArgs
