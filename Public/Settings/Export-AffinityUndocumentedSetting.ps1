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

function Export-AffinityUndocumentedSetting {
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'AutoName')]
    [Alias('Export-AUSetting')]
    [OutputType([string])]
    param (
        # Credential
        [Parameter(Mandatory = $false,
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [pscredential]
        $Credentials = $AffinityUndocumentedCredentials,

        # AutoName: Settings Directory
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'AutoName',
                   Position = 1)]
        [string]
        $SettingDir = (Get-AffinityUndocumentedSettingDir),

        # AutoName: Setting Name
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'AutoName',
                   Position = 2)]
        [string]
        $SettingName = (Get-AffinityUndocumentedSettingName -UserName $AffinityUndocumentedCredentials.UserName),

        # ManualName: Path
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'ManualName',
                   Position = 1)]
        [string]
        $SettingPath
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'AutoName'      { $ExportPath = Join-Path -Path $SettingDir -ChildPath $SettingName }
            'ManualName'    { $ExportPath = $SettingPath }
            Default         { <# Throw error #> }
        }

        New-Item -Path $ExportPath -Force | Out-Null

        @{
            'Domain'        = $MyInvocation.MyCommand.ModuleName
            'Credentials'   = $Credentials
        } | Export-Clixml -Path $ExportPath -Force | Out-Null

        if (Test-Path $ExportPath) { return $ExportPath }
        else { throw [System.IO.FileNotFoundException] "Setting failed to be exported" }
    }
}