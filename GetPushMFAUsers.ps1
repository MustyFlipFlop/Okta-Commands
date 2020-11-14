Connect-Okta "TOKEN" https://dev-______.okta.com/

$user = Get-OktaUser "me"


function Get-MfaUsers() {
    $totalUsers = 0
    $mfaUsers = @()
    # for more filters, see https://developer.okta.com/docs/api/resources/users#list-users-with-a-filter
    $params = @{filter = 'status eq "ACTIVE"'}
    do {
        $page = Get-OktaUsers @params
        $users = $page.objects
        foreach ($user in $users) {
            $factors = Get-OktaFactors $user.id

            $sms = $factors.where({$_.factorType -eq "sms"})
            $push = $factors.where({$_.factorType -eq "push"})

            $mfaUsers += [PSCustomObject]@{
                id = $user.id
                name = $user.profile.login
                sms = $sms.factorType
                sms_enrolled = $sms.created
                sms_status = $sms.status
                push = $push.factorType
                push_enrolled = $push.created
                push_status = $push.status
            }
        }
        $totalUsers += $users.count
        $params = @{url = $page.nextUrl}
    } while ($page.nextUrl)
    $mfaUsers | Export-Csv mfaUsers.csv -notype
    "$totalUsers users found."
}