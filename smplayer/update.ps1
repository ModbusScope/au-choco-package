import-module au

$releases = 'https://sourceforge.net/projects/smplayer/files/SMPlayer'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*packageName\s*=\s*)('.*')"  = "`$1'$($Latest.PackageName)'"
            "(?i)(^\s*softwareName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)*'"
        }

        ".\legal\verification.txt" = @{
          "(?i)(\s+x32:).*"        = "`${1} $($Latest.URL32)"
          "(?i)(\s+x64:).*"        = "`${1} $($Latest.URL64)"
          "(?i)(checksum32:).*"    = "`${1} $($Latest.Checksum32)"
          "(?i)(checksum64:).*"    = "`${1} $($Latest.Checksum64)"
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -FileNameSkip 1 -NoSuffix }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $url = $download_page.links | ? {
        if (!$_.href) { return }
        $v = $_.href.split('/', [System.StringSplitOptions]::RemoveEmptyEntries)[-1]
        [version]::TryParse($v, [ref]($__)) } | select -First 1 -Expand href

    $version = $url.split('/', [System.StringSplitOptions]::RemoveEmptyEntries)[-1]

    $releases = 'https://sourceforge.net' + $url
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $url32 = $download_page.links | ? href -match '-win32-qt5.6.exe/download' | % href
    $url64 = $download_page.links | ? href -match '-x64\.exe/download' | % href
    if (!$url32 -and !$url64) {
        Write-Host 'No Windows binaries found'
        return 'ignore'
    }

    @{
        Version = $version
        URL32   = $url32
        URL64   = $url64
        FileType = 'exe'
    }
}

update -ChecksumFor none
