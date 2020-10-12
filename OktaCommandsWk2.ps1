Connect-Okta "00nqUTefiidY53JNDWLrnzqJJCzISgdrmqjepysCSc" https://dev-ryanhightower.okta.com/

$user = Get-OktaUser "me"

$profile = @{login = "rm.hightower+1@gmail.com"; email = "rm.hightower+1@gmail.com"; firstName = "Ryan"; lastName = "Hightower"}
$user = New-OktaUser @{profile = $profile}

$profile = @{name = "TestGroup"; description = "This is a test"}
$group = New-OktaGroup @{profile = $profile}

$user = Get-OktaUser "me"
$group = Get-OktaGroups "TestGroup" 'type eq "OKTA_GROUP"'
Add-OktaGroupMember $group.id $user.id

$params = @{filter = 'status eq "ACTIVE"'}
do {
    $page = Get-OktaUsers @params
    $users = $page.objects
    foreach ($user in $users) {
        # Add more properties here:
        Write-Host $user.profile.login $user.profile.email
    }
    $params = @{url = $page.nextUrl}
} while ($page.nextUrl)