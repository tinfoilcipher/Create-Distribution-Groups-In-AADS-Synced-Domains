#Create Exchange Online Distribution Group in ADDS Environment - A Welsh 2018
Clear-Host

#Modules
Import-Module ActiveDirectory

#Constants
$strOU = "" #-OU DNAME
[int]$intDepart = 0 #--Set to control if members can leave the group
[int]$intJoin = 0 #--Set to control is members can join the group

#Enter Variables
$strName = Read-Host "Enter Group Name> "
$strSamAccountName = Read-Host "Enter samAccountName (One Word)> "
$strDisplayName = Read-Host "Enter Display Name> "
$strDescription = Read-Host "Enter Description (Optional)> "
$strPrefix = Read-Host "Enter SMTP Prefix (Email Address Before @r-m-t.co.uk)> "
$strSMTP = ($strPrefix + "@r-m-t.co.uk")
$strProxy = ("SMTP:" + $strPrefix + "@r-m-t.co.uk")
Write-Host "Externally Available? No (0) Yes (1)"
$strRouting = Read-Host ">"
Write-Host "Hide In GAL? No (0) Yes (1)"
$strGAL = Read-Host ">"

#Create Group
New-ADGroup -Name $strName -SamAccountName $strSamAccountName -GroupCategory Distribution -GroupScope Universal -DisplayName $strDisplayName -Path $strOU -Description $strDescription

#Set Static Values
$strNewGroup = Get-ADGroup -Identity $strSamAccountName -Properties *
Set-ADObject -identity $strNewGroup -replace @{msExchGroupDepartRestriction=$intDepart}
Set-ADObject -identity $strNewGroup -replace @{msExchGroupJoinRestriction=$intJoin}
Set-ADObject -identity $strNewGroup -replace @{mail=$strSMTP}
Set-ADObject -identity $strNewGroup -replace @{proxyAddresses=$strProxy}


#Set variable values (Internal/External)
If ($strRouting -gt "0"){
	Set-ADObject -identity $strNewGroup -replace @{msExchRequireAuthToSendTo=$FALSE}
}
ElseIf ($strRouting -eq "0"){
	Set-ADObject -identity $strNewGroup -replace @{msExchRequireAuthToSendTo=$TRUE}
}

#Set variable values (Hidden from GAL)
If ($strRouting -gt "0"){
	Set-ADObject -identity $strNewGroup -replace @{msExchHideFromAddressLists=$TRUE}
}

Write-Host "Group Created. Add Users in AD Manually."
Write-Host "Then either run an ADDS Delta Sync or wait for replication."
Write-Host "Press Return to Close."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$host.SetShouldExit(0)
exit
