# Get public and private function definition files
$script:Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1     -Recurse -ErrorAction SilentlyContinue )
$script:Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1    -Recurse -ErrorAction SilentlyContinue )
$script:Class   = @( Get-ChildItem -Path $PSScriptRoot\Class\*.ps1      -Recurse -ErrorAction SilentlyContinue )
$script:Enum    = @( Get-ChildItem -Path $PSScriptRoot\Enum\*.ps1       -Recurse -ErrorAction SilentlyContinue )

# Dot source the files
Foreach($Import in @($Enum + $Class + $Public + $Private)) {
    Try { . $($Import.FullName) }
    Catch { Write-Error -Message "Failed to import function $($Import.FullName): $_" }
}

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.

Export-ModuleMember -Function $Public.BaseName

# Note: You cannot create cmdlets in a script module file, but you can import cmdlets from a binary module into a script module and re-export them from the script module.