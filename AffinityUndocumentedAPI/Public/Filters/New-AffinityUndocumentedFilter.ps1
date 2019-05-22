<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    The component this cmdlet belongs to
.ROLE
    The role this cmdlet belongs to
.FUNCTIONALITY
    The functionality that best describes this cmdlet
#>
function New-AffinityUndocumentedFilter {
    [CmdletBinding(DefaultParameterSetName='Filter',
                   PositionalBinding=$false)]
    [Alias('New-AUFilter')]
    Param (
        # Field ID
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [int]
        $FieldID,
        
        # Condition Type
        [Parameter(Mandatory = $false,
                   Position = 1,
                   ParameterSetName='Filter')]
        [ValidateNotNullOrEmpty()]
        [AffinityUndocumentedConditionType]
        $ConditionType = [AffinityUndocumentedConditionType]::Filter,
        
        # Values
        [Parameter(Mandatory = $true,
                   Position = 2,
                   ParameterSetName = 'Filter')]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $Values
    )
    
    process {
        [AffinityUndocumentedFilter]::new($FieldID, $Values)
    }
}