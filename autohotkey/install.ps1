set-executionpolicy unrestricted -scope process
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # restart if we are not an admin because ahk2exe demands it
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

$startup_folder = [Environment]::GetFolderPath('Startup')
$startup_exe = "$($startup_folder)/wincontrol.exe"

write-output "Compiling 'ahk2exe /in wincontrol.ahk /out wincontrol.exe..."
ahk2exe /icon "wincontrol.ico" /in wincontrol.ahk /out wincontrol.exe

write-output "Move wincontrol.exe to $($startup_exe)..."
write-output "This can fail if the file is open..."
move-item wincontrol.exe -force -destination $startup_exe

write-output "Done, starting wincontrol.exe..."
start-process -FilePath $startup_exe

start-sleep -s 10