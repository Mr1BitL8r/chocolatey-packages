import-module au

$releases = 'https://www.synology.com/en-us/releaseNote/NoteStationClient'
$synology_note_station_client_base_url = 'https://global.download.synology.com/download/Utility/NoteStationClient/'

function global:au_SearchReplace {
    @{
       ".\legal\VERIFICATION.txt" = @{
          "(?i)(\s+x32:).*"            = "`${1} $($Latest.URL32)"
          "(?i)(\s+x64:).*"            = "`${1} $($Latest.URL64)"
          "(?i)(checksum32:).*"        = "`${1} $($Latest.Checksum32)"
          "(?i)(checksum64:).*"        = "`${1} $($Latest.Checksum64)"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
     }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }
function global:au_GetLatest {
    # Get the content of the website with the release notes
    $release_versions_page = Invoke-WebRequest -Uri $releases
    #Write-Host "Release version page: $release_versions_page"
    # Use a regular expression to look for all the data in the form of e.g. "data-version=2.2.2-609" in the website
    $found = "$release_versions_page" -match '.*data-version="(\d+\.\d+\.\d+\-\d+)".*'
    if ($found) {
        # Use the first found entry matching the regex as latest version as this one shows up first on the website (latest entry is first)
        $latest_version = $matches[1]
    }
    #Write-Host "Found: $found"
    #Write-Host "Latest version: $latest_version"
    
    $url32   = $synology_note_station_client_base_url + $latest_version + '/Windows/i686/synology-note-station-client-' + $latest_version + '-win-x86-Setup.exe'
    $url64   = $synology_note_station_client_base_url + $latest_version + '/Windows/x86_64/synology-note-station-client-' + $latest_version + '-win-x64-Setup.exe'
    # Replace the '-' with a '.' to match the Chocolatey versioning schema
    $version = $latest_version -replace "\-", "."

    return @{
        Version = $version
        URL32 = $url32
        URL64 = $url64
        ReleaseNotes = "$releases"
    }
}

update -ChecksumFor none
#au_GetLatest