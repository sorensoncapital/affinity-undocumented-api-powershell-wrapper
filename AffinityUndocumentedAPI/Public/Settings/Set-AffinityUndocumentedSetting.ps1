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
   Notes
#>

function Set-AffinityUndocumentedSetting {
    [CmdletBinding(PositionalBinding = $true)]
    [Alias('Set-AUSetting')]
    [OutputType([bool])]
    param (
        # Credentials
        [Parameter(Mandatory = $false,
                   Position = 0)]
        [pscredential]
        $Credentials = (
            Get-Credential -Title 'Affinity Credentials' `
                           -Message 'Please enter Affinity user name and password'
        )
    )

    Set-Variable -Name AffinityUndocumentedCredentials `
                 -Scope Script `
                 -Value $Credentials `
                 -Option ReadOnly `
                 -Force `
                 -ErrorAction Stop | Out-Null
    
    return $true
}