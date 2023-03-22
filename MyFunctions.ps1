function GetUserData {
    $MyUserListFile = "$PSScriptRoot\MyLabFile.csv"
    $CSV = Import-Csv -Path $MyUserListFile
    return $CSV
}