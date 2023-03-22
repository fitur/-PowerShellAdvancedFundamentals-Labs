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
    return GetUserData | Where-Object {($_.Name -match $Name) -and ($_.Age -gt $OlderThan)}
}

function Add-CourseUser {
    [CmdletBinding()]
    param (
        [Parameter(mandatory=$false, HelpMessage="Specify a file.")]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]$MyUserListFile = "$PSScriptRoot\MyLabFile.csv",

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
    
    # Create file if not exist
    if (-not (Test-Path -Path $MyUserListFile)) {
        Set-Content -Value "Name,Age,Color,Id" -Path $MyUserListFile
    }
    
    # Read file content
    $NewCSv = Get-Content $MyUserListFile -Raw

    # Add input to variable
    $MyCsvUser = "$Name,$Age,{0},{1}" -f $Color, $UserID

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
        [System.IO.FileInfo]$MyUserListFile = "$PSScriptRoot\MyLabFile.csv"
    )

    Begin {
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
    }

    Process {
        $MyUserList = Get-Content -Path $MyUserListFile | ConvertFrom-Csv
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
            $ConfirmPreference = 'None'
            Write-Host -ForegroundColor Red "Removing $($RemoveUser.Name)"
            Set-Content -Value  ($MyUserList | ConvertTo-Csv -NoTypeInformation -UseQuotes Never) -Path $MyUserListFile -Confirm:$false
        } else {
            Write-Host -ForegroundColor Red "Did not remove user $($RemoveUser.Name)"
        }
    }
}