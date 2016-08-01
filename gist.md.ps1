# Update-AUPackages
[![](https://ci.appveyor.com/api/projects/status/9ipva7kgjigug2rn?svg=true)](https://ci.appveyor.com/project/majkinetor/chocolatey/build/$Env:APPVEYOR_BUILD_ID)
[![](https://img.shields.io/badge/AU%20packages-$($Info.result.all.Length)-red.svg)](#ok)
[![](https://img.shields.io/badge/AU-$(gmo au -ListAvailable | % Version | select -First 1 | % { "$_"} )-blue.svg)](https://www.powershellgallery.com/packages/AU)

_This file is automatically generated by the [update_all.ps1](https://github.com/majkinetor/chocolatey/blob/master/update_all.ps1) script using the [AU module](https://github.com/majkinetor/au) ( [view source](https://github.com/majkinetor/chocolatey/blob/master/gist.md.ps1) )._

|||
|---               | --- |
**Time (UTC)**     | $($Info.startTime.ToUniversalTime().ToString('yyyy-MM-dd HH:mm'))
**Git repository** | https://github.com/majkinetor/chocolatey

$(
    $OFS="`r`n"

    $icon_ok = 'https://cdn0.iconfinder.com/data/icons/shift-free/32/Complete_Symbol-128.png'
    $icon_er = 'https://cdn0.iconfinder.com/data/icons/shift-free/32/Error-128.png'

    if ($Info.error_count.total) {
        "<img src='$icon_er' width='48'> **LAST RUN HAD $($Info.error_count.total) [ERRORS](#errors) !!!**" }
    else {
        "<img src='$icon_ok' width='48'> Last run was OK"
    }

    md_code $Info.stats

    if ($Info.pushed) {
        md_title Pushed
        md_table $Info.result.pushed -Columns 'PackageName', 'Updated', 'Pushed', 'RemoteVersion', 'NuspecVersion'
    }

    if ($Info.error_count.total) {
        md_title Errors
        md_table $Info.result.errors -Columns 'PackageName', 'NuspecVersion', 'Error'
        $Info.result.errors | % {
            md_title $_.PackageName -Level 3
            md_code "$($_.Error)"
        }
    }

    if ($Info.result.ok) {
        md_title OK
        md_table $Info.result.ok -Columns 'PackageName', 'Updated', 'Pushed', 'RemoteVersion', 'NuspecVersion'
        $Info.result.ok | % {
            md_title $_.PackageName -Level 3
            md_code $_.Result
        }
    }
)
