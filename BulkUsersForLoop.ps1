Connect-Okta "TOKEN" https://dev-________.okta.com
Get-OktaUser "me"
function New-Users($numUsers) {
    $now = Get-Date -Format "yyyyMMddHHmmss"
    for ($i = 1; $i -le $numUsers; $i++) {
        $profile = @{login="a$now$i@okta.com"; email="testuser$i@okta.com"; firstName="test"; lastName="ZExp$i"}
        try {
            $user = New-OktaUser @{profile = $profile; credentials = @{password = @{value = "Password123"}}} $false
            Write-Host $i
        } catch {
            Get-Error $_
        }
    }
}
