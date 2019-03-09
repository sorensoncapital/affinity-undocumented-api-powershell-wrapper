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

function Get-AffinityUndocumentedSettingName {
    [CmdletBinding()]
    [Alias('Get-AUSettingName')]
    param (
        # UserName
        [Parameter(Mandatory = $true)]
        [string]
        $UserName
    )
    
    process { 
       	( $MyInvocation.MyCommand.ModuleName + "_" + `
       	$env:COMPUTERNAME + "_" + `
       	$env:USERNAME + "_" + `
       	$UserName + ".cred" ) 
   	}
}