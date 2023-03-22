function GetUserData {
    [CmdletBinding()]
    param (
        [Parameter(mandatory=$false)]
        [System.IO.FileInfo]$MyUserListFile = "$PSScriptRoot\MyLabFile.csv"
    )
    #$MyUserListFile = "$PSScriptRoot\MyLabFile.csv"
    #$CSV = Import-Csv -Path $MyUserListFile
    $CSV = Import-Csv -Path $MyUserListFile
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
        $UserData = GetUserData
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

function Add-CourseUser {
    [CmdletBinding()]
    param (
        [Parameter(mandatory=$false, HelpMessage="Specify a file.")]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]$DatabaseFile = "$PSScriptRoot\MyLabFile.csv",

        [Parameter(mandatory=$true, HelpMessage="Specify a first and last name.")]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(mandatory=$true, HelpMessage="Specify an age in digits.")]
        [ValidateNotNullOrEmpty()]
        [int]$Age,

        [Parameter(mandatory=$true, HelpMessage="Specify an a color, either red, green, blue or yellow.")]
        [ValidateSet('red','green','blue','yellow')]
        [string]$Color,

        [Parameter(mandatory=$false, Helpmessage="Specify a user ID in digits.")]
        [ValidateNotNullOrEmpty()]
        [string]$UserID = (Get-Random -Minimum 10 -Maximum 100000)
    )
    
    # Read file content if exist else initialize
    if (-not (Test-Path -Path $DatabaseFile)) {
        Set-Content -Value "Name,Age,Color,Id" -Path $DatabaseFile
    }
    $NewCSv = Get-Content $DatabaseFile -Raw

    # Add input to variable
    $MyCsvUser = "$Name,$Age,{0},{1}" -f $Color, $UserID

    # Add variable to 
    $NewCSv += $MyCsvUser
    Set-Content -Value $NewCSv -Path $DatabaseFile
}