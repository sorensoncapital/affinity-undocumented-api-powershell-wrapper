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
function Get-AffinityUndocumentedListEntries
{
    [CmdletBinding(PositionalBinding = $true)]
    [Alias('Get-AUListEntries')]
    [OutputType([Array])]
    Param
    (
        # Affinity list_id
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $ListID,

        # Affinity undocumented filters
        [Parameter(Mandatory = $false)]
        [AffinityUndocumentedFilter[]]
        $Filters,

        # Export to CSV
        [Parameter(Mandatory = $false)]
        [switch]
        $Export
    )

    Process {
        $Fragment = 'lists/{0}/entries' -f $ListID

        if ($Filters) {
            $queries = New-Object System.Collections.ArrayList($null)
            
            foreach ($filter in $Filters) { $queries.Add( $filter.ToURLQueryString() ) }
            
            $Fragment += '?' + ($queries -join '&')
        }

        Invoke-AffinityUndocumentedAPIRequest -Method Get -Fragment $Fragment
    }
}