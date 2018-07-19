$oldpasswords = get-aduser -Filter "Enabled -eq '$True'" -Properties Name,
                                                                     mail,
                                                                     passwordlastset,
                                                                     Lastlogondate,
                                                                     cannotchangepassword,
                                                                     passwordneverexpires,
                                                                     passwordexpired |
    Where-Object {$_.passwordlastset -le (get-date).AddDays(-46) -and !($_.cannotchangepassword)} |
    Select-Object -Property Name,
                            Mail,
                            PasswordLastSet,
                            @{n='PasswordExpires'; e={($_.passwordlastset).adddays(60)}},
                            lastlogondate, 
                            @{n="PasswordStatus"; e={if($_.PasswordNeverExpires -eq $True) {"Password Does not Expire"}
                                                     elseif($_.passwordExpired -eq $True) {"Expired"}
                                                     elseif($_.passwordlastset -le (Get-Date).AddDays(-53)) {"Password Expires This Week"}
                                                     else{"Password Expires next week or other"}
                                                    }
                             } 

$oldpasswords | Export-Csv -Path C:\reports\PasswordStatus.csv

$expiringpasswords = $oldpasswords |
                        Where-Object {$_.PasswordStatus -like "Password Expires*"} |
                        Sort-Object -Property PasswordExpires |
                        out-string

if ($expiringpasswords -ne $null) {
    Send-MailMessage -To "ksexson@cattle-empire.net" -From "Password Expiration <it@cattle-empire.net>" -SmtpServer "mail.cattle-empire.net" -Body $expiringpasswords -Subject "Passwords expiring soon"
}