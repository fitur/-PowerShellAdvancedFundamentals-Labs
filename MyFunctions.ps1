enum ColorEnum {
    red
    green
    blue
    yellow
}

###
class User {
    [string] $Name
    [int] $Age
    [ColorEnum] $Color 
    [int] $Id

    User([String]$Name, [int]$Age, [ColorEnum]$Color, [int]$Id) {
        $This.Name = $Name
        $This.Age = $Age
        $This.Color = $Color
        $This.Id = $Id
    }

    [string] ToString() {
        Return '{0},{1},{2},{3}' -f $This.Name, $This.Age, $This.Color, $This.Id
    }
}

###

function GetUserData {
    [CmdletBinding()]
    param (
        [Parameter(mandatory=$false)]
        [System.IO.FileInfo]$MyUserListFile = "$PSScriptRoot\MyLabFile.csv"
    )
    $MyUserList = Get-Content -Path $MyUserListFile | ConvertFrom-Csv
    return $MyUserList
}

function Get-CourseUser {
    [CmdletBinding()]
    param (
        [Parameter(mandatory=$false, HelpMessage="Specify a first and last name.")]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(mandatory=$false, HelpMessage="Specify an age in digits.")]
        [ValidateNotNullOrEmpty()]
        [int]$OlderThan = 65
    )
    
    # When Name might be unspecified, Where-Object matches all, else only specified
    $Result = GetUserData
    Write-Output $Result | Where-Object {($_.Name -match $Name) -and ($_.Age -gt $OlderThan)}
}

function Add-CourseUser {
    [CmdletBinding()]
    param (
        [Parameter(mandatory=$false, HelpMessage="Specify a file.")]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]$MyUserListFile = "$PSScriptRoot\MyLabFile.csv",

        [Parameter(mandatory=$true, HelpMessage="Specify a first and last name.")]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[A-Z][\w\-\s]*$', ErrorMessage = 'Name is in an incorrect format', Options = 'None')]
        [string]$Name,

        [Parameter(mandatory=$true, HelpMessage="Specify an age in digits.")]
        [ValidateNotNullOrEmpty()]
        [int]$Age,

        [Parameter(mandatory=$true, HelpMessage="Specify an a color, either red, green, blue or yellow.")]
        [ValidateNotNullOrEmpty()]
        [ColorEnum]$Color,

        [Parameter(mandatory=$false, Helpmessage="Specify a user ID in digits.")]
        [ValidateNotNullOrEmpty()]
        [string]$UserID = (Get-Random -Minimum 10 -Maximum 100000)
    )
    
    # Create file if not exist
    if (-not (Test-Path -Path $MyUserListFile)) {
        Set-Content -Value "Name,Age,Color,Id" -Path $MyUserListFile
    }
    
    # Read file content
    $NewCSv = Get-Content $MyUserListFile -Raw

    # Add input to variable
    $MyNewUser = [User]::new($Name, $Age, $Color, $UserID)
    $MyCsvUser = $MyNewUser.ToString()

    # Add variable to user list
    $NewCSv += $MyCsvUser

    # Save user
    Set-Content -Value $NewCSv -Path $MyUserListFile
}

function Remove-CourseUser {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param (
        [Parameter(mandatory=$false, HelpMessage="Specify a file.")]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]$DatabaseFile = "$PSScriptRoot\MyLabFile.csv"
    )

    $MyUserList = Get-Content -Path $DatabaseFile | ConvertFrom-Csv
    $RemoveUser = $MyUserList | Out-GridView -PassThru
    $MyUserList = $MyUserList | Where-Object {
        -not (
            $_.Name -eq $RemoveUser.Name -and
            $_.Age -eq $RemoveUser.Age -and
            $_.Color -eq $RemoveUser.Color -and
            $_.Id -eq $RemoveUser.Id
        )
    }

    # Execute change if based on confirmation and impact
    if ($PSCmdlet.ShouldProcess([string]$RemoveUser.Name)) {
    #if ($PSCmdlet.ShouldProcess($DatabaseFile)) {
        $ConfirmPreference = 'None'
        Write-Output -ForegroundColor Red "Removing $($RemoveUser.Name)"
        Set-Content -Value  ($MyUserList | ConvertTo-Csv -NoTypeInformation -UseQuotes Never) -Path $DatabaseFile -Confirm:$false
    } else {
        Write-Output -ForegroundColor Red "Did not remove user $($RemoveUser.Name)"
    }
}

function Confirm-CourseID {
    param (
        
    )
    $UserData = GetUserData
    $UserData | ForEach-Object {
        if ($_.Id -notmatch '^\d+$') {
            Write-Output "$($_.Name) has faulty ID: $($_.Id)"
        }
    }
}

function Get-JSONStuff {
    param (
        $URI = "https://jsonplaceholder.typicode.com/posts/12"
    )
    Invoke-RestMethod -Uri $URI
}

function Post-JSONStuff {
    param (
        $URI = "https://jsonplaceholder.typicode.com/posts",
        $Message
    )

    $Body = @{
        title = 'post'
        body = $Message
        userId = 1
    } | ConvertTo-Json
    

    Invoke-RestMethod -Method Post -ContentType 'application/json' -Body $Body -Uri $URI
}

function GetCDs {
    param (
        $URI = 'https://www.w3schools.com/xml/cd_catalog.xml'
    )
    (Invoke-RestMethod -Uri $URI).CATALOG.CD
}

function Select-CDInfoAsJson {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(ValueFromPipeline)]
        $CD
    )

    Write-Output $CD | Select-Object TITLE,ARTIST | ConvertTo-Json
}