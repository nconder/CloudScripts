# Oct 06 2021
# Get Azure RBAC with or with out Inheritance from all resources with PowerShell
# Module required for Excel report
#Install-Module -Name ImportExcel -Scope Currentuser
$Testsub='xxx-xxx-xxx-xxx-xxx'
$Prodsub='xxx-xxx-xxx-xxx-xxx'
$Devsub='xxx-xxx-xxx-xxx-xxx'
# Set subscription
Set-AzContext -subscriptionId $Devsub

# Get Azure resources and Role Assignments and set var
# For each role get rbac then add resource back into the results
$Resource=Get-AzResource 
$RoleAssignments=New-Object System.Collections.Generic.List[PSObject]
foreach($r in $Resource){
    $Assignment=Get-AzRoleAssignment -ResourceName $r.Name -ResourceGroupName $r.ResourceGroupName -ResourceType $r.ResourceType
    foreach($a in $Assignment){
       $IsInherited=if($r.ResourceId -eq $a.Scope){$false}else{$true}

       $a | Add-member -NotePropertyName ResourceName -NotePropertyValue $r.Name
       $a | Add-member -NotePropertyName ResourceId -NotePropertyValue $r.ResourceId
       $a | Add-member -NotePropertyName IsInherited -NotePropertyValue $IsInherited
       $RoleAssignments.Add($a)
    }
}
# Export results auto size and auto filter
$RoleAssignments  | Export-Excel -Path "c:\temp\Dev_AzRoleAssignmentsByResource_WithInheritance.xlsx" -Autosize -AutoFilter
#No Inheritance
#$RoleAssignments | where {$_.IsInherited -eq $false} | Export-Excel -Path "c:\temp\Dev_AzRoleAssignmentsByResource_NoInheritance.xlsx" -Autosize -AutoFilter
