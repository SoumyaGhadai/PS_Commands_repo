$command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
Invoke-Expression $command
Invoke-WebRequest -Uri "https://s3.amazonaws.com/ddagent-windows-stable/datadog-agent-7-latest.amd64.msi" -Outfile C:\datadog-agent-7-latest.amd64.msi
$arguments = "/i `"C:\datadog-agent-7-latest.amd64.msi`" /quiet"
Start-Process -Wait msiexec -ArgumentList '/qn /i "C:\datadog-agent-7-latest.amd64.msi" APIKEY="yo-put-api-key-here!!!!"'
