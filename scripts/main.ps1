[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSAvoidUsingWriteHost', '',
    Justification = 'Want to just write to the console, not the pipeline.'
)]
[CmdletBinding()]
param()

#Requires -Modules Utilities

$path = (Join-Path -Path $PSScriptRoot -ChildPath 'helpers') | Get-Item | Resolve-Path -Relative
LogGroup "Loading helper scripts from [$path]" {
    Get-ChildItem -Path $path -Filter '*.ps1' -Recurse | Resolve-Path -Relative | ForEach-Object {
        Write-Host "$_"
        . $_
    }
}

LogGroup 'Loading inputs' {
    $moduleName = if ([string]::IsNullOrEmpty($env:PSMODULE_BUILD_PSMODULE_INPUT_Name)) {
        $env:GITHUB_REPOSITORY_NAME
    } else {
        $env:PSMODULE_BUILD_PSMODULE_INPUT_Name
    }
    Write-Host "Module name:         [$moduleName]"
    Set-GitHubOutput -Name ModuleName -Value $moduleName

    $sourceFolderPath = Join-Path -Path $env:PSMODULE_BUILD_PSMODULE_INPUT_Path -ChildPath 'src'
    if (-not (Test-Path -Path $sourceFolderPath)) {
        throw "Source folder path [$sourceFolderPath] does not exist."
    }

    $moduleOutputFolderPath = Join-Path $env:PSMODULE_BUILD_PSMODULE_INPUT_Path -ChildPath 'outputs/module'
    Write-Host "Modules output path: [$moduleOutputFolderPath]"
}

LogGroup 'Build local scripts' {
    Write-Host 'Execution order:'
    $scripts = Get-ChildItem -Filter '*build.ps1' -Recurse | Sort-Object -Property Name | Resolve-Path -Relative
    $scripts | ForEach-Object {
        Write-Host " - $_"
    }
    $scripts | ForEach-Object {
        LogGroup "Build local scripts - [$_]" {
            . $_
        }
    }
}

$params = @{
    ModuleName             = $moduleName
    ModuleSourceFolderPath = $sourceFolderPath
    ModuleOutputFolderPath = $moduleOutputFolderPath
}
Build-PSModule @params

exit 0
