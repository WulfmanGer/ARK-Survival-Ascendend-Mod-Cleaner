<#
.SYNOPSIS
    ARK: Survival Ascended Single Mod Remover – deletes all occurrences of a specific Mod ID.

.DESCRIPTION
    • Removes all entries with the given Mod ID from library.json
    • Deletes all associated mod folders from disk
    • Creates a backup of the original library.json before modifying

.PARAMETER ModID
    The numeric Mod ID to remove (as listed under "id" in the JSON).

.EXAMPLE
    ./mod_delete_single.ps1 123456

.NOTES
    Author      : WulfmanGER
    Repository  : https://github.com/WulfmanGer/ARK-Survival-Ascendend-Mod-Cleaner
    Version     : 1.0.1
    Last Update : 2026-01-27
    Tested on   : Windows 11 • PowerShell 7.5.1 (PowerShell 5.1 needs UTF-8-BOM-Formatted File!)

.HOW TO USE
    1. Open PowerShell
    2. Navigate to the folder where this script is saved
    3. Run: ./mod_delete_single.ps1 123456
       (Replace 123456 with the Mod ID you want to remove)

.LICENSE
    GNU General Public License v3.0
	(C) 2025 WulfmanGER – github.com/WulfmanGER

#>

param (
    [Parameter(Mandatory = $true)]
    [string]$modId
)

# === USER CONFIGURATION ===
$gamePath = "G:\Spiele\Steam\steamapps\common\ARK Survival Ascended"
$jsonId = "83374"

# === Paths ===
$jsonPath = Join-Path $gamePath "ShooterGame\Binaries\Win64\ShooterGame\ModsUserData\$jsonId\library.json"
$backupJsonPath = "$jsonPath.bak"
$modsDir = Join-Path $gamePath "ShooterGame\Binaries\Win64\ShooterGame\Mods\$jsonId"

# === Backup library.json ===
if (Test-Path $jsonPath) {
    Copy-Item -Path $jsonPath -Destination $backupJsonPath -Force
    Write-Host "✅ Backup of library.json created at: $backupJsonPath"
} else {
    Write-Error "JSON file not found at $jsonPath"
    exit
}

# === Load JSON ===
$jsonRaw = Get-Content -Raw -Path $jsonPath
$data = $jsonRaw | ConvertFrom-Json

# === Find matching mods by details.iD ===
# We use string comparison to ensure ID matching works regardless of type
$matchingMods = $data.installedMods | Where-Object { "$($_.details.iD)" -eq "$modId" }

if ($null -eq $matchingMods -or $matchingMods.Count -eq 0) {
    Write-Warning "No mods found with Mod ID: $modId"
    exit
}

Write-Host "`n🔍 Found the following matching mod entries:"
foreach ($mod in $matchingMods) {
    Write-Host "🆔 Mod ID: $($mod.details.iD)"
    Write-Host "📛 Name: $($mod.details.name)"
    Write-Host "📁 Path: $($mod.pathOnDisk)"
    Write-Host ""
}

# === Confirm ===
$confirm = Read-Host "Do you want to remove ALL of these entries and their folders? (yes/no)"
if ($confirm -ne "yes") {
    Write-Host "Aborted by user."
    exit
}

# === Remove from JSON (by details.iD) ===
$filteredMods = $data.installedMods | Where-Object { "$($_.details.iD)" -ne "$modId" }

# Force array structure (@) to prevent JSON corruption if only one mod remains
$data.installedMods = @($filteredMods)

# === Save JSON with UTF-8-BOM and Windows CRLF ===
$newJsonString = $data | ConvertTo-Json -Depth 100 -Compress
$utf8WithBom = New-Object System.Text.UTF8Encoding($true)

# Ensure Windows Line Endings (CRLF) and single-line format
$newJsonString = $newJsonString -replace "`n", "`r`n"
[System.IO.File]::WriteAllText($jsonPath, $newJsonString, $utf8WithBom)

Write-Host "`n✅ Mod entries removed from JSON. File updated (UTF-8-BOM)."

# === Delete folders ===
Write-Host "`n🧹 Deleting associated mod folders..."
foreach ($mod in $matchingMods) {
    $relativePath = $mod.pathOnDisk -replace "^$jsonId[\\/]", ""
    $modPath = Join-Path $modsDir $relativePath

    if (Test-Path $modPath) {
        try {
            Remove-Item -Path $modPath -Recurse -Force -ErrorAction Stop
            Write-Host "🗑️  Deleted: $relativePath"
        } catch {
            Write-Warning "Could not delete: $modPath - $_"
        }
    } else {
        Write-Warning "Path not found: $modPath"
    }
}

Write-Host "`n✅ Operation completed."
Write-Host "Please test the game now. Backup is at: $backupJsonPath"
Write-Host "Backup of original JSON is located at:"
Write-Host $backupJsonPath -ForegroundColor Cyan
Write-Host "`nPlease test the game before deleting this backup manually."
