

function Create-User {
    [CmdletBinding()]
    param (
        [string] $NewLocalAdmin,
        [securestring] $Password
    )    
    begin {
    }    
    process {
        New-LocalUser "$NewLocalAdmin" -Password $Password -FullName "$NewLocalAdmin" -Description "Temporary local admin"
        Write-Verbose "$NewLocalAdmin local user crated"
        Add-LocalGroupMember -Group "Administrators" -Member "$NewLocalAdmin"
        Write-Verbose "$NewLocalAdmin added to the local administrator group"
    }    
    end {
    }
}

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }


$NewLocalAdmin = "AdminTemp"
$Password = ConvertTo-SecureString "*******" -AsPlainText -Force
Create-User -NewLocalAdmin $NewLocalAdmin -Password $Password -Verbose

$tempfolders = @(�C:\Windows\Temp\*�, �C:\Windows\Prefetch\*�, �C:\Documents and Settings\*\Local Settings\temp\*�, �C:\Users\*\Appdata\Local\Temp\*�)
Remove-Item $tempfolders -force -recurse