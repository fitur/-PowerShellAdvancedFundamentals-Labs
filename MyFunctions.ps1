function GetUserData {
    [CmdletBinding()]
    param (
        [Parameter(mandatory=$true)]
        [System.IO.FileInfo]$InputFile
    )
    #$MyUserListFile = "$PSScriptRoot\MyLabFile.csv"
    #$CSV = Import-Csv -Path $MyUserListFile
    $CSV = Import-Csv -Path $InputFile
    return $CSV
}

function Get-CourseUser {
    [CmdletBinding()]
    param (
        [Parameter(mandatory=$false)]
        [String]$Name,
        [Parameter(mandatory=$false)]
        [int]$OlderThan
    )
    
    begin {
        # Get user data from helper function
        $UserData = GetUserData -InputFile "C:\Git\-PowerShellAdvancedFundamentals-Labs\MyLabFile.csv"
    }
    
    process {
        # If a name is given, return only specific user
        if (![String]::IsNullOrEmpty($Name)) {
            Write-Host "Name to look for: $Name"
            Write-Host "List size $($UserData.Count)"
            $UserData = $UserData | Where-Object {$_.Name -match $Name}
        } else {
            $UserData = $UserData
        }

        # If an age is given, return only older than that value
        if ($null -ne $OlderThan) {
            Write-Host "Age to look for: $OlderThan"
            $UserData = $UserData | Where-Object {$_.Age -gt $OlderThan}
        } else {
            $UserData = $UserData
        }
    }
    
    end {
        # Return data
        return $UserData
    }
}