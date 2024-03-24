#Get machine Tags 
$machineId = (invoke-webrequest http://169.254.169.254/latest/meta-data/instance-id -UseBasicParsing).Content
$machineTags = @()
try {
  $machineTags = (aws ec2 describe-tags --filters "Name=resource-id,Values=${machineId}" | ConvertFrom-Json).Tags
} 
catch {
  Write-Host "An error occurred"
  $machineTags = Get-EC2Tag -Filter @{Name="resource-id";Values=$machineId}
}

foreach ($machineTag in $machineTags) 
{
    if ($machineTag.Key -eq 'env') {$env += $machineTag.Value.Trim().Replace("-", "_").Replace(" ", "_")}
    if ($machineTag.Key -eq 'app') {$app += $machineTag.Value.Trim().Replace("-", "_").Replace(" ", "_")}
    if ($machineTag.Key -eq 'client') {$client += $machineTag.Value.Trim().Replace("-", "_").Replace(" ", "_")}
    if ($machineTag.Key -eq 'Name') {$name += $machineTag.Value.Trim().Replace("-", "_").Replace(" ", "_")}
}
$tags = "$($client),$($env),$($app),$($ems),$($name)"

#Declare path over here 
$CrashPath = "C:\flx-ekd\DMServer\config"
$DumpPath =  "C:\Users\sso-soumya.ghadai\AppData\Local\atlas64.DMP"
$buildPath = "C:\flx-ekd\bin64"
$Date = (Get-Date).AddDays(-1).ToString('MM-dd-yyyy')
$ipv4 = (Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"}).IPv4Address.IPAddress

#Crashes
# function Crashes{
# 	$Crashes = (Get-ChildItem -Path $CrashPath | Where-Object {$_.Name -match "flxcrash*" -or $_.Name -match ".xtr"})
# 	cd $CrashPath
# 	foreach ($Crash in $Crashes) 
# 	{
# 		aws s3 cp $Crash s3://xtr-official/Crashes/$Client/$env/$Date/$ipv4/$Crash --acl bucket-owner-full-control --storage-class "ONEZONE_IA"
# 	}
# }

#Dumps
function Dumps{
	$Dumps = (Get-ChildItem -Path $DumpPath | Where-Object {$_.Name -match ".DMP"})
	cd $DumpPath
	foreach ($Dump in $Dumps) 
	{
		aws s3 cp $Dump s3://xtr-official/Dumps/$Client/$env/$Date/$ipv4/$Dump --acl bucket-owner-full-control --storage-class "ONEZONE_IA"
	}
}

#AutoBuild
function AutoBuild{
	$builds = (Get-ChildItem -Path $buildPath | Where-Object {$_.Name -match "Build*"})
	cd $buildPath
	foreach ($build in $builds) 
	{
		aws s3 cp $build s3://xtr-official/Dumps/$Client/$env/$Date/$ipv4/$build --acl bucket-owner-full-control --storage-class "ONEZONE_IA"
	}
}

#Method Calling 
# Crashes
Dumps
AutoBuild
