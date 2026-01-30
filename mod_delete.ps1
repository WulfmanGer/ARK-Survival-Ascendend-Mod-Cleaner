<#
.SYNOPSIS
    ARK: Survival Ascended Mod Cleaner – removes all non-Custom Cosmetic mods or rejected Custom Cusmetics

.DESCRIPTION
    • Creates backups of library.json and the Mods folder
    • Logs mods slated for deletion
    • Updates library.json and deletes corresponding mod directories

.NOTES
    Author      : WulfmanGER
    Repository  : https://github.com/WulfmanGer/ARK-Survival-Ascendend-Mod-Cleaner
    Version     : 1.0.4
    Last Update : 2026-01-30
    Tested on   : Windows 11 • PowerShell 7.5.1

.LICENSE
    GNU General Public License v3.0
	(C) 2025 WulfmanGER – github.com/WulfmanGER
#>


# === USER CONFIGURATION ===
# Change this path to your ARK Survival Ascended installation folder
$gamePath = "G:\Spiele\Steam\steamapps\common\ARK Survival Ascended"

# === DO NOT EDIT BELOW ===
$jsonId = "83374"
$jsonPath = Join-Path $gamePath "ShooterGame\Binaries\Win64\ShooterGame\ModsUserData\$jsonId\library.json"
$backupJsonPath = "$jsonPath.bak"
$logPath = Join-Path $gamePath "ShooterGame\Binaries\Win64\ShooterGame\ModsUserData\$jsonId\mod_delete.log"

$modsDir = Join-Path $gamePath "ShooterGame\Binaries\Win64\ShooterGame\Mods\$jsonId"
$modsBackupDir = Join-Path $gamePath "ShooterGame\Binaries\Win64\ShooterGame\Mods_backup\$jsonId"

# Delete the log file if it exists
if (Test-Path $logPath) {
    Remove-Item -Path $logPath -Force
}
# Create a new empty log file with UTF-8 encoding
[System.IO.File]::WriteAllText($logPath, "", [System.Text.Encoding]::UTF8)

# === Backup JSON file ===
if (Test-Path $jsonPath) {
    Copy-Item -Path $jsonPath -Destination $backupJsonPath -Force
} else {
    Write-Error "JSON file not found at $jsonPath"
    exit
}

# === Backup MODS directory ===
if (-Not (Test-Path $modsBackupDir)) {
    New-Item -Path $modsBackupDir -ItemType Directory -Force | Out-Null
}

Write-Host "Backing up Mods directory..."
Copy-Item -Path "$modsDir\*" -Destination $modsBackupDir -Recurse -Force
Write-Host "Mods backup created at: $modsBackupDir"

# === Load JSON ===
$jsonRaw = Get-Content -Raw -Path $jsonPath
$data = $jsonRaw | ConvertFrom-Json

# Helper function to check if a mod is a Custom Cosmetic (ID 6844)
function Is-Cosmetic($mod) {
    # Check primary category
    if ($mod.details.primaryCategoryId -eq 6844) { return $true }
    # Check all assigned categories in the array
    foreach ($category in $mod.details.categories) {
        if ($category.iD -eq 6844) { return $true }
    }
    return $false
}

# === Identify mods to delete ===
# Delete if: (It is NOT a cosmetic) OR (Status is 'Deleted')
$modsToDelete = $data.installedMods | Where-Object {
    $isCosmetic = Is-Cosmetic $_
    
    # NEW LOGIC: 
    # Delete if: 
    # 1. It's NOT a cosmetic 
    # 2. OR local status is 'Deleted' 
    # 3. OR CurseForge status (details) is 'Deleted'
    ($isCosmetic -eq $false) -or 
    ($_.status -eq "Deleted") -or 
    ($_.details.status -eq "Deleted")
}

if ($null -eq $modsToDelete -or $modsToDelete.Count -eq 0) {
    Write-Host "`nNo mods found that match the deletion criteria." -ForegroundColor Green
    exit
}

# Write delete log (pathOnDisk | name)
$logEntries = $modsToDelete | ForEach-Object {
    "$($_.pathOnDisk) | $($_.details.name)"
}
$logEntries | Set-Content -Path $logPath -Encoding UTF8

# Show delete log
Write-Host "`nThe following mods are proposed for deletion (Non-Cosmetics or Status:Deleted):`n"
$logEntries | ForEach-Object { Write-Host " - $_" }

# Confirm before continuing
$confirm = Read-Host "`nDo you want to remove these mods from the JSON file and delete their folders? (yes/no)"
if ($confirm -ne "yes") {
    Write-Host "Aborted by user."
    exit
}

# === Modify JSON Object ===
# Keep if: (It IS a cosmetic) AND (Status is NOT 'Deleted')
$filteredMods = $data.installedMods | Where-Object {
    $isCosmetic = Is-Cosmetic $_
    # Keep only if it IS a cosmetic AND neither status is 'Deleted'
    ($isCosmetic -eq $true) -and 
    ($_.status -ne "Deleted") -and 
    ($_.details.status -ne "Deleted")
}
# Force array structure even if only 1 mod remains
$data.installedMods = @($filteredMods)

# Convert to single-line JSON string
$newJsonString = $data | ConvertTo-Json -Depth 100 -Compress

# === Save JSON with UTF-8-BOM and Windows CRLF ===
$utf8WithBom = New-Object System.Text.UTF8Encoding($true)
# Ensure Windows Line Endings (CRLF)
$newJsonString = $newJsonString -replace "`n", "`r`n"
[System.IO.File]::WriteAllText($jsonPath, $newJsonString, $utf8WithBom)

Write-Host "`nMods removed from JSON. File updated (UTF-8-BOM, Single-line)."

# === Delete MOD-Folders ===
Write-Host "Deleting associated mod folders..."
foreach ($mod in $modsToDelete) {
    # Extract folder name from pathOnDisk (e.g., "83374/12345" -> "12345")
    $relativePath = $mod.pathOnDisk -replace "^$jsonId[\\/]", ""
    $modPath = Join-Path $modsDir $relativePath
    
    if (Test-Path $modPath) {
        try {
            Remove-Item $modPath -Recurse -Force -ErrorAction Stop
            Write-Host "Deleted folder: $relativePath"
        } catch {
            Write-Warning "Could not delete folder: $modPath"
        }
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
