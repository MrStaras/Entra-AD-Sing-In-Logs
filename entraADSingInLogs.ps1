Import-Module Microsoft.Graph.Reports
Import-Module Microsoft.Graph.Users

Connect-MgGraph -Scopes "AuditLog.Read.All", "Group.Read.All" -NoWelcome

$groupId = ""

$groupMembers = Get-MgGroupMember -GroupId $groupId -All | ForEach-Object {
    Get-MgUser -UserId $_.Id
}

$time = (Get-Date).ToUniversalTime().AddDays(-7).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")

$allSignIns = Get-MgAuditLogSignIn -Filter "createdDateTime ge $time" -All

$results_array = @()

foreach ($groupMember in $groupMembers) {

    $userPrincipalName = $groupMember.userPrincipalName

    $userSignIns = $allSignIns | Where-Object {
        $_.UserPrincipalName -eq $userPrincipalName -and
        $_.Location.CountryOrRegion -ne "Country_Code" -and
        $_.AppDisplayName -ne "applicatoin name"
    }

    foreach ($signIn in $userSignIns) {
        
        $status = if ($signIn.Status.ErrorCode -eq 0) {
            "Success"
        } else {
            "Failed"
        }
        
        $results_array += [PSCustomObject]@{
            Date            = $signIn.CreatedDateTime.ToString("yyyy-MM-dd")
            UserDisplayName = $signIn.UserDisplayName
            Country         = $signIn.Location.CountryOrRegion
            City            = $signIn.Location.City
            IPAddress       = $signIn.IPAddress
            App             = $signIn.AppDisplayName
            Status          = $status
            ErrorCode       = $signIn.Status.ErrorCode
        }
    }
}

$results_array = $results_array | Sort-Object Date -Descending

$results_array | Format-Table -AutoSize

Disconnect-MgGraph | Out-Null
