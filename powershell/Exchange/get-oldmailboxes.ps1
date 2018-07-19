get-mailbox |
    Get-MailboxStatistics -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |
    ? {$_.lastlogontime -le ((get-date).AddDays(-60))} |
    Select -Property @{n="alias"; e={get-mailbox $_.identity | Select-Object -ExpandProperty alias}},
                     displayname,
                     ItemCount,
                     totalitemsize,
                     lastlogontime,
                     identity

$archivepath = "\\exchange-be01\c`$\Archive"