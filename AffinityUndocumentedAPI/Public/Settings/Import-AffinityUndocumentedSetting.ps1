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

function Import-AffinityUndocumentedSetting {
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'AutoName')]
    [Alias('Import-AUSetting')]
    [OutputType([bool])]
    param (
        # AutoName: Settings Directory
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'AutoName',
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SettingDir = (Get-AffinityUndocumentedSettingDir),

        # AutoName: Username
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'AutoName',
                   Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SettingUserName,

        # ManualName: Path
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'ManualName',
                   Position = 0)]
        [string]
        $SettingPath
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'AutoName' { 
                $ImportPath = Join-Path -Path $SettingDir `
                                        -ChildPath (Get-AffinityUndocumentedSettingName -UserName $SettingUserName)
            }
            'ManualName' { 
                $ImportPath = $SettingPath
            }
            Default { <# Throw error #> }
        }

        if (Test-Path $ImportPath) { 
            $ImportedSetting = Import-Clixml -LiteralPath $ImportPath
            
            if ($ImportedSetting.Domain -ilike $MyInvocation.MyCommand.ModuleName) {
                Set-AffinityUndocumentedSetting -Credentials $ImportedSetting.Credentials
            }
            else { throw [System.NotSupportedException] ("Setting for different domain {0}" -f $ImportedSetting.Domain) }
        }
        else { throw [System.IO.FileNotFoundException] "Setting failed to be imported" }
    }
}