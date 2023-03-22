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
    
}

