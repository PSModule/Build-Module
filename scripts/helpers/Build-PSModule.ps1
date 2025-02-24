function Build-PSModule {
    <#
        .SYNOPSIS
        Builds a module.

        .DESCRIPTION
        Builds a module.
    #>
    [OutputType([void])]
    [CmdletBinding()]
    #Requires -Modules @{ ModuleName = 'GitHub'; ModuleVersion = '0.13.2' }
    #Requires -Modules @{ ModuleName = 'Utilities'; ModuleVersion = '0.3.0' }
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSReviewUnusedParameter', '', Scope = 'Function',
        Justification = 'LogGroup - Scoping affects the variables line of sight.'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingWriteHost', '', Scope = 'Function',
        Justification = 'Want to just write to the console, not the pipeline.'
    )]
    param(
        # Name of the module.
        [Parameter(Mandatory)]
        [string] $ModuleName,

        # Path to the folder where the modules are located.
        [Parameter(Mandatory)]
        [string] $ModuleSourceFolderPath,

        # Path to the folder where the built modules are outputted.
        [Parameter(Mandatory)]
        [string] $ModuleOutputFolderPath
    )

    LogGroup "Building module [$ModuleName]" {
        $moduleSourceFolder = Get-Item -Path $ModuleSourceFolderPath
        Write-Host "Module source folder: [$moduleSourceFolder]"
        $moduleOutputFolder = New-Item -Path $ModuleOutputFolderPath -Name $ModuleName -ItemType Directory -Force
        Write-Host "Module output folder: [$moduleOutputFolder]"
    }

    Build-PSModuleBase -ModuleName $ModuleName -ModuleSourceFolder $moduleSourceFolder -ModuleOutputFolder $moduleOutputFolder
    Build-PSModuleManifest -ModuleName $ModuleName -ModuleOutputFolder $moduleOutputFolder
    Build-PSModuleRootModule -ModuleName $ModuleName -ModuleOutputFolder $moduleOutputFolder
    Update-PSModuleManifestAliasesToExport -ModuleName $ModuleName -ModuleOutputFolder $moduleOutputFolder # TODO: Use AST to find aliases to export.

    LogGroup 'Build manifest file - Final Result' {
        $outputManifestPath = Join-Path -Path $ModuleOutputFolder -ChildPath "$ModuleName.psd1"
        Show-FileContent -Path $outputManifestPath
    }
}
