<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
#>

function Get-AffinityUndocumentedSettingDir {
    [Alias('Get-AUSettingDir')]
    param()  
    process { (Join-Path -Path (Get-Location) -ChildPath 'settings') }
}