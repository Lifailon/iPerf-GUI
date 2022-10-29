$iperf = ".\iperf\iperf3.exe"

function menu {

$ip = ipconfig
$ip = $ip -match "IPv4 Address"
$ip = $ip -replace "   IPv4 Address. . . . . . . . . . . : ",""
cls
Write-Host "Server:"
hostname
Write-Host
Write-Host "Address:"
$ip

Write-Host
Write-Host "Menu:" -ForegroundColor Green
Write-Host "1." -ForegroundColor Green -nonewline
" Start Server"
Write-Host "2." -ForegroundColor Green -nonewline
" Start Server to Port"
Write-Host "3." -ForegroundColor Green -nonewline
" Status Server"
Write-Host "4." -ForegroundColor Green -nonewline
" Connect Client to Server"
Write-Host "5." -ForegroundColor Green -nonewline
" Check Port"
Write-Host "6." -ForegroundColor Green -nonewline
" Opened Port (Run as Administrator)"
Write-Host "7." -ForegroundColor Green -nonewline
" WMI Hardware Report"

Write-Host
$num=Read-Host "Enter Number"

if ($num -eq 4) {script-2} elseif ($num -eq 7) {script-3} else {script-1}
}

function script-1 {
if ($num -eq 1) {$port_server = 5201}
if ($num -eq 1) {Start-Process -FilePath "$iperf" -ArgumentList "-s -D"}

if ($num -eq 2) {$port_server=Read-Host "Enter Number Port"}
if ($num -eq 2) {Start-Process -FilePath "$iperf" -ArgumentList "-s -D -p $port_server"}

if ($num -eq 3) {cls}
if ($num -eq 3) {Write-Host}
if ($num -eq 3) {Write-Host "Status Server:"}
if ($num -eq 3) {Write-Host}
if ($num -eq 3) {Get-Process | Where ProcessName -match "iperf" | select ProcessName, StartTime}
if ($num -eq 3) {$wshell = New-Object -ComObject Wscript.Shell}
if ($num -eq 3) {$Output = $wshell.Popup("Stop server iPerf ?",0,"iPerf",4)}
if ($num -eq "3" -and $output -eq "6") {Get-Process | Where ProcessName -match "iperf" | Stop-Process}
if ($num -eq 3) {Get-Process | Where ProcessName -match "iperf"}

if ($num -eq 5) {cls}
if ($num -eq 5) {$srv_test=Read-Host "Enter Name Server"}
if ($num -eq 5) {$ping = ping $srv_test -n 1}
if ($num -eq 5) {if ($ping[2] -match "Reply") {
Write-Host "Connect icmp host: $srv_test" -ForegroundColor Green} else {
Write-Host "No connect icmp host: $srv_test" -ForegroundColor Red
}
}
if ($num -eq 5) {$port_test=Read-Host "Enter Number Port"}
if ($num -eq 5) {$test = Test-NetConnection $srv_test -p $port_test}
if ($num -eq 5) {$test = $test.TcpTestSucceeded}
if ($num -eq 5) {if ($test -match "True") {
Write-Host "Opened Port: $port_test" -ForegroundColor Green
}
else {
Write-Host "Closed Port: $port_test" -ForegroundColor Red
}
}
if ($num -eq 5) {pause}

if ($num -eq 6) {$port_fw=Read-Host "Enter Number Port"}
if ($num -eq 6) {netsh advfirewall firewall add rule name="$port_fw-IPAdmin" dir=in action=allow localport=$port_fw protocol=TCP enable=yes}
if ($num -eq 6) {netsh advfirewall firewall show rule name="$port_fw-IPAdmin"}
if ($num -eq 6) {pause}

if ($num -match "[0-9]") {cls}
if ($num -match "[0-9]") {menu}
}

function script-2 {

$srv=Read-Host "Enter Name Server"

$log_path_up = ".\"+"$srv"+"-up"+".log"
$log_path_down = ".\"+"$srv"+"-down"+".log"
$traffic = "1Gb"


$ping = ping $srv -n 1
cls
Write-Host
if ($ping[2] -match "Reply") {
Write-Host "Connect icmp host: $srv" -ForegroundColor Green
}
else {
Write-Host "No connect icmp host: $srv" -ForegroundColor Red
}

Write-Host
Write-Host "1." -ForegroundColor Green -nonewline
" Check Speed Upload"
Write-Host "2." -ForegroundColor Green -nonewline
" Check Speed Download"
Write-Host "3." -ForegroundColor Green -nonewline
" Check Speed Upload to Port and Streams"
Write-Host "4." -ForegroundColor Green -nonewline
" Check Speed Download to Port and Streams"
Write-Host
Write-Host "q" -ForegroundColor Green -nonewline
" - quit back"
Write-Host

$num_test=Read-Host "Enter Number Check"

if ($num_test -eq 1) {Start-Process -FilePath "$iperf" -ArgumentList "-c $srv -n $traffic --logfile $log_path_up"}

if ($num_test -eq 2) {Start-Process -FilePath "$iperf" -ArgumentList "-c $srv -R -n $traffic --logfile $log_path_down"}

if ($num_test -eq 3) {$port_client=Read-Host "Enter Number Port"}
if ($num_test -eq 3) {$stream=Read-Host "Enter Number Streams"}
if ($num_test -eq 3) {Start-Process -FilePath "$iperf" -ArgumentList "-c $srv -n $traffic -p $port_client -P $stream --logfile $log_path_up"}

if ($num_test -eq 4) {$port_client=Read-Host "Enter Number Port"}
if ($num_test -eq 4) {$stream=Read-Host "Enter Number Streams"}
if ($num_test -eq 4) {Start-Process -FilePath "$iperf" -ArgumentList "-c $srv -R -n $traffic -p $port_client -P $stream --logfile $log_path_down"}

if ($num_test -match "q") {menu}

cls
script-2
}

function script-3 {

cls

$srv=Read-Host "Enter Name Server"

Invoke-Command -ComputerName $srv -ScriptBlock {Get-ComputerInfo | select CsName, CsDNSHostName, OsName, OsVersion, OsBuildNumber, OsLocale, OsLanguage, OsInstallDate, OsUptime, CsProcessors, CsNumberOfProcessors, CsNumberOfLogicalProcessors, CsManufacturer, CsModel}

gwmi Win32_ComputerSystem -ComputerName $srv

gwmi Win32_BaseBoard -ComputerName $srv | select Manufacturer, Model, Product | fl

gwmi Win32_Processor -ComputerName $srv

gwmi Win32_VideoController -ComputerName $srv | select SystemName, Name, Caption, Description, CurrentHorizontalResolution, CurrentVerticalResolution

gwmi Win32_NetworkAdapter -ComputerName $srv | select ServiceName, Name, MACAddress, AdapterType, Speed

gwmi Win32_PhysicalMemory -ComputerName $srv | select DeviceLocator, Manufacturer, PartNumber, Capacity, ConfiguredClockSpeed, Speed, ConfiguredVoltage
gwmi Win32_MemoryDevice -ComputerName $srv | select Name, Caption, Description, DeviceID, StartingAddress, EndingAddress

Invoke-Command -ComputerName $srv -ScriptBlock {Get-ComputerInfo | ft @{Label="All Memory Size"; Expression={$_.CsPhyicallyInstalledMemory/1024}}, @{Label="Free Memory Size"; Expression={$_.OsFreePhysicalMemory/1024}}}

gwmi Win32_DiskDrive -ComputerName $srv | where {$_.Partitions -gt 0}

gwmi Win32_logicalDisk -ComputerName $srv | ft DeviceID, @{Label="Free Space Disk"; Expression={[string]([int]($_.FreeSpace/1Gb))+" GB"}}, @{Label="Full Size GB"; Expression={[string]([int]($_.Size/1Gb))+" GB"}}

$disk = Invoke-Command -ComputerName $srv -ScriptBlock {Get-PSDrive}
$disk | Where {$_.Name -match "\b[A-Z]\b"}

gwmi Win32_Product -ComputerName $srv | select Name, Version, InstallLocation | ft

pause
menu
}

menu