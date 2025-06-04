<#
.SYNOPSIS
    ARK: Survival Ascended Mod Cleaner – removes all non-Custom Cosmetic mods.

.DESCRIPTION
    • Creates backups of library.json and the Mods folder
    • Logs mods slated for deletion
    • Updates library.json and deletes corresponding mod directories

.NOTES
    Author      : WulfmanGER
    Repository  : https://github.com/WulfmanGer/ARK-Survival-Ascendend-Mod-Cleaner
    Version     : 1.0.0
    Last Update : 2025-06-05
    Tested on   : Windows 11 • PowerShell 7.5.1

.LICENSE
    MIT License (see repository for details)
#>


# === USER CONFIGURATION ===
# Change this path to your ARK Survival Ascended installation folder
$gamePath = "G:\Spiele\Steam\steamapps\common\ARK Survival Ascended"

# === DO NOT EDIT BELOW ===
$jsonPath = Join-Path $gamePath "ShooterGame\Binaries\Win64\ShooterGame\ModsUserData\83374\library.json"
$backupJsonPath = "$jsonPath.bak"
$logPath = Join-Path $gamePath "ShooterGame\Binaries\Win64\ShooterGame\ModsUserData\83374\mod_delete.log"

$modsDir = Join-Path $gamePath "ShooterGame\Binaries\Win64\ShooterGame\Mods\83374"
$modsBackupDir = Join-Path $gamePath "ShooterGame\Binaries\Win64\ShooterGame\Mods_backup\83374"

# === Backup JSON file ===
Copy-Item -Path $jsonPath -Destination $backupJsonPath -Force

# === Backup MODS directory ===
if (-Not (Test-Path $modsBackupDir)) {
    New-Item -Path $modsBackupDir -ItemType Directory -Force | Out-Null
}

Write-Host "Backing up Mods directory..."
Copy-Item -Path "$modsDir\*" -Destination $modsBackupDir -Recurse -Force

Write-Host "Mods backup created at:"
Write-Host $modsBackupDir

# === Load and filter JSON ===
$data = Get-Content -Raw -Path $jsonPath | ConvertFrom-Json

# Identify mods to delete (everything that is NOT a Custom Cosmetic, ID 6844)
$modsToDelete = $data.installedMods | Where-Object {
    $_.details.primaryCategoryId -ne 6844
}

# Write delete log (pathOnDisk | name)
$logEntries = $modsToDelete | ForEach-Object {
    "$($_.pathOnDisk) | $($_.details.name)"
}
$logEntries | Set-Content -Path $logPath -Encoding UTF8

# Show delete log
Write-Host "`nThe following mods are proposed for deletion:`n"
Get-Content $logPath | ForEach-Object { Write-Host $_ }
Write-Host ""

# Confirm before continuing
$confirm = Read-Host "Do you want to remove these mods from the JSON file? (yes/no)"

if ($confirm -ne "yes") {
    Write-Host "Aborted by user."
    exit
}

# === Modify JSON ===
$data.installedMods = $data.installedMods | Where-Object {
    $_.details.primaryCategoryId -eq 6844
}

# Save updated JSON
$data | ConvertTo-Json -Depth 100 -Compress | Set-Content -Path $jsonPath -Encoding UTF8

Write-Host "`nMods removed from JSON. File updated."
# === Delete MOD-Folders  ===
Write-Host "`nDelete associated mod folders..."

foreach ($mod in $modsToDelete) {
    $relativePath = $mod.pathOnDisk -replace "^83374[\\/]", ""
    $modPath = Join-Path $modsDir $relativePath

    if (Test-Path $modPath) {
        try {
            Remove-Item -Path $modPath -Recurse -Force -ErrorAction Stop
            Write-Host "Deleted: $modPath"
        } catch {
            Write-Warning "Could not delete: $modPath - $_"
        }
    } else {
        Write-Warning "Path not found: $modPath"
    }
}

# === FINAL NOTE ===
Write-Host "`n✅ Operation completed."
Write-Host "Your backups are located here:"
Write-Host "📄 JSON Backup: " -NoNewline
Write-Host "$backupJsonPath" -ForegroundColor Cyan
Write-Host "📁 Mods Backup: " -NoNewline
Write-Host "$modsBackupDir" -ForegroundColor Cyan


Write-Host "`nPlease test the game now. If everything works, you can delete the backups manually."


#$open = Read-Host "open backup folder? (yes/no)"
#if ($open -eq "yes") {
#    Start-Process $modsBackupDir
#    Start-Process (Split-Path $backupJsonPath)
#}
