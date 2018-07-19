$schedule = New-JobTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Monday -At 9am 
$scheduleoptions = New-ScheduledJobOption -WakeToRun 
$jobname = "WeeklyJobs"

Register-ScheduledJob -Name $jobname -FilePath C:\scripts\weeklyjobs.ps1 -Trigger $schedule -ScheduledJobOption $scheduleoptions