class AffinityUndocumentedFilter {
    # Properties
    [ValidateNotNullOrEmpty()][int]$FieldID
    [ValidateNotNullOrEmpty()][AffinityUndocumentedConditionType]$ConditionType
    [int[]]$Values

    # Constructor: Filter (ConditionType::Filter)
    AffinityUndocumentedFilter([int]$fid, [int[]]$v) {
        $this.FieldID = $fid
        $this.ConditionType = [AffinityUndocumentedConditionType]::Filter
        $this.Values = $v
    }

    # Constructor: Blank (ConditionType::Blank)
    AffinityUndocumentedFilter([int]$fid) {
        $this.FieldID = $fid
        $this.ConditionType = [AffinityUndocumentedConditionType]::Blank
    }

    #Method: Create string of URL parameters
    [string] ToURLQueryString() {
        $pairs = New-Object System.Collections.ArrayList($null)
        $pairs.Add(('filters[{0}][conditionType]={1}' -f $this.FieldID, $this.ConditionType.value__))

        switch ($this.ConditionType) {
            ([AffinityUndocumentedConditionType]::Filter) { 
                foreach ($v in $this.Values) {
                    $pairs.Add(('filters[{0}][values][]={1}' -f $this.FieldID, $v))
                } 
            }
            ([AffinityUndocumentedConditionType]::Blank) { }
            Default { <# Throw error #> }
        }
        
        return $pairs -join '&'
    }
}