$CompObject =  Get-WmiObject -Class WIN32_OperatingSystem
$Memory = ((($CompObject.TotalVisibleMemorySize - $CompObject.FreePhysicalMemory)*100)/$CompObject.TotalVisibleMemorySize)
Write-Host "Memory usage in Percentage:" $Memory
