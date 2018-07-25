# Create-Distribution-Groups-In-AADS-Synced-Domains
Script for creating Exchange Online Distribution Groups in Active Directory domains which are mastered by Azure AD Connect Sync

## OUTLINE</br>
The purpose of this script is to attempt to automate the process of creating Distribution Groups in Active Directory domains
following a cutover migration to Office 365 Exchange Online.</br>
</br>
Many orginizations wish to keep their groups on-premise rather than make the move wholesale to Exchange Online (and this is the
default configuration during a migration). However following the migration and decom of Exchange the creation of a Distribution
group is far more cumbersome as the attributes written to AD automatically by Exchange all need to be done manually.

## PREREQUISITES</br>
Powershell v2 or higher</br>
ActiveDirectory PowerShell Module</br>

## USE</br>
The following constants must be set before use<br>
1. **$strOU**: Set as the distinguishedName of the OU that the group is to be created in
2. **$intDepart**: Numerical value representing if members can/can't leave the group 0=Closed 1=Open 2=ApprovalRequired
3. **$intJoin**: Numerical value representing if members can/can't leave the group 0=Closed 1=Open 2=ApprovalRequired

The script will prompt for the requistive values when executed. **Name**, **samAccountName**, **Display Name** and **Email Address**
then ask if the group should be externally available and/or hidden from the GAL. The attribute set is then defined and will be
synced to Azure as and when your next Delta sync runs.

By default, the user executing the script will be set as owner and no members will be added, however since this is no great
hardship to do in the GUI it has not been included.
