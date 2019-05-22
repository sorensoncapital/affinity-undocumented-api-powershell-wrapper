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
function Invoke-AffinityUndocumentedAPIRequest
{
    [CmdletBinding(PositionalBinding = $true)]
    [Alias('Invoke-AUAPIRequest')]
    [OutputType([PSCustomObject])]
    Param
    (
        # Affinity Logged In Web Session
        [Parameter(Mandatory = $false, 
                   Position = 0)]
        [ValidateNotNullorEmpty()]
        [Microsoft.PowerShell.Commands.WebRequestSession]
        $WebSession = $AffinityUndocumentedLoggedInWebSession,

        # HTTP Method
        [Parameter(Mandatory = $false,
                   Position = 1)]
        [ValidateNotNullorEmpty()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method=[Microsoft.PowerShell.Commands.WebRequestMethod]::Get,

        # Affinity API Base URL
        [Parameter(Mandatory = $false,
                   Position = 2)]
        [ValidateNotNullorEmpty()]
        [string]
        $AffinityBaseUrl = $AffinityUndocumentedBaseUrl,

        # Affinity API URL fragment
        [Parameter(Mandatory = $true,
                   Position = 3)]
        [ValidateNotNullorEmpty()]
        [String]
        $Fragment,

        # Content
        [Parameter(Mandatory = $false,
                   Position = 4)]
        $Content
    )

    Process {
        Invoke-RestMethod -Uri ("{0}/{1}" -f $AffinityBaseUrl, $Fragment) `
                          -Body $Content `
                          -WebSession $WebSession `
                          -Method $Method
    }
}