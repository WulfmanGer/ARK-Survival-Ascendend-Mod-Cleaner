# ARK: Survival Ascended – Mod Remover Script 🇩🇪

🧹 PowerShell script for cleaning up server-side mods from the `library.json` of the game **ARK: Survival Ascended**. Custom cosmetics will not be deleted! The reason for this is that broken mods that are no longer needed can still cause problems. For me, it was the "invisible inventory" bug.

---

## What does the script do?

This PowerShell script:

1. Creates a backup of the `library.json` file (this contains all mods)
2. Creates a backup of the mod directory
3. Lists all mods that are not custom cosmetics
4. Writes this list to a log file (`mod_delete.log`)
5. Asks you if you want to remove these mods from the JSON file
6. Then deletes the associated mod folders
7. Shows paths to the backups at the end for manual review

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
