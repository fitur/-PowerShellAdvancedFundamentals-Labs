function GetUserData {
    param (
        [System.IO.FileInfo]$InputFile
    )
    $MyUserListFile = "$PSScriptRoot\MyLabFile.csv"
    $CSV = Import-Csv -Path $MyUserListFile
    return $CSV
}

function Get-CourseUser {
    
}