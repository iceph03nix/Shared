#$command = Restart-Computer -ComputerName $servers
$servers = "accounting-01"
$schedule = New-JobTrigger -Weekly -DaysOfWeek Monday, Tuesday, Wednesday,Thursday, Friday -At 4am
$scheduleoptions = New-ScheduledJobOption -RunElevated -WakeToRun
$jobname = "RebootServer"

Register-ScheduledJob -Name $jobname -ScriptBlock {Restart-Computer -ComputerName $servers -Force} -Trigger $schedule -ScheduledJobOption $scheduleoptions
#Register-ScheduledJob -Name $jobname -FilePath '\\adfs-01\Scripts$\passwordstatuscheck.ps1' -Trigger $schedule -ScheduledJobOption $scheduleoptions

#oneliner
#Register-ScheduledJob -name "Reboot Later" -ScriptBlock {Restart-Computer -Force} -Trigger (New-JobTrigger -Once -at "01/29/18 09:00:00") 