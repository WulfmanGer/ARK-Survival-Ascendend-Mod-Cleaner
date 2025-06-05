## Important note
We strongly recommend using PowerShell 7.x. Using PowerShell 5.1 (the default) may cause errors (saving the script as a UTF8 BOM (Notepad++, for example) helps). PowerShell 7.x is installed via the MS Store - search for "Powershell" (provided by Microsoft). Then install. More information to follow! **please share your feedback with 5.1**! I don't have the time right now to test it thoroughly.

# ARK: Survival Ascended – Mod Cleaner Script

🧹 PowerShell script for cleaning up server-side mods from the `library.json` of the game **ARK: Survival Ascended**. Custom cosmetics will not be deleted! The reason for this is that broken mods that are no longer needed can still cause problems. For me, it was the "invisible inventory" bug. Server-side mods are reloaded when you join a server with the corresponding mods.

---

## What does the script do?

This PowerShell script:

1. Creates a backup of the `library.json` file (this contains all mods)
2. Creates a backup of the mod directory
3. Lists all mods that are not custom cosmetics
4. Writes this list to a log file (`mod_delete.log`)
5. Asks you if you want to remove these mods (from the library.json and from the mod folder)
6. Shows paths to the backups at the end for manual review

---

## 🛠️ Usage

### Requirements

- Windows with PowerShell
- Write permissions in the ARK directory

### Instructions

1. Download the `mod_cleaner.ps1` file
2. Open it in a text editor
3. Enter your ARK Survival Ascended installation path:

```powershell
$gamePath = "G:\Games\Steam\steamapps\common\ARK Survival Ascended"
```
4. Run the script: Open File Explorer with the folder where you saved mod_delete.ps1. Press SHIFT+right-click -> select "Open PowerShell window here." Run the script with .\mod_delete.ps1

### Download the PowerShell script from GitHub

1. Open the script on GitHub (e.g., mod_cleaner.ps1)
2. Click "Raw" in the top right corner
3. Your browser will now only display the script content.
4. Right-click → "Save As..." → Make sure the file is saved as .ps1 (not .txt or .html)
