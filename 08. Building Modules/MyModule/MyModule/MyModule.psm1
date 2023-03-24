Write-Output "testing"
# Import classes and enums
foreach ($Item in (Get-ChildItem -Path "$PSScriptRoot\Classes" -Filter "*.ps1")) {
    try {
        Write-Host "Importing $($Item.FullName)"
        . $Item.FullName
    }
    catch {
        Write-Error "Failed to import $($Item.FullName)"
    }
}

# Import private
foreach ($Item in (Get-ChildItem -Path "$PSScriptRoot\Private" -Filter "*.ps1")) {
    try {
        Write-Host "Importing $($Item.FullName)"
        . $Item.FullName
    }
    catch {
        Write-Error "Failed to import $($Item.FullName)"
    }
}

# Import public
foreach ($Item in (Get-ChildItem -Path "$PSScriptRoot\Public" -Filter "*.ps1")) {
    try {
        Write-Host "Importing $($Item.FullName)"
        . $Item.FullName
    }
    catch {
        Write-Error "Failed to import $($Item.FullName)"
    }
}