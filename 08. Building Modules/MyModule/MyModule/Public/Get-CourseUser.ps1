function Get-CourseUser {
    <#
    .SYNOPSIS
        This function retrieves the course users.
    .DESCRIPTION
        A longer descripion of how this function retrieves the course users.
    .NOTES
        Information or caveats about the function which retrieves the course users.
    .LINK
        https://www.aftonbladet.se
    .EXAMPLE
        Get-CourseUser -Name "Syd"
        This command will retrieve all users named Syd.
    #>
    
    
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Name,
        
        [Parameter()]
        [int]$OlderThan
    )

    $Result = GetUserData

    if (-not [string]::IsNullOrEmpty($Name)) {
        $Result = $Result | Where-Object -Property Name -Like "*$Name*"
    }
    
    if ($OlderThan) {
        $Result = $Result | Where-Object -Property Age -ge $OlderThan
    }

    $Result
}