# Todo
1. "Wrong" Folder for mod_delete.log --> its in Gamepath ... should be in same folder like libray.json
2. Parameter to delete ALL Custom Cosmetics
3. Option: Nur Mods löschen die bei Curseforge entfernt wurden.


# Changelog
**mod_delete.ps1 v1.0.1**
2025-06-20: Bug: A display error occurred when the script was called again even though there were no mods to delete. This was due to incorrect handling of the mod_delete.log file. This file is now recreated before startup and is therefore always empty at the beginning.
**mod_delete.ps1 v1.0.2**
2025-06-24: New Feature: Mods that were removed from Curseforge will now also be deleted.
**mod_delete.ps1 v1.0.3** 
2026-01-27: Fixed: Improved detection logic to include mods that have "Custom Cosmetics" (ID 6844) as a secondary category. Fixed encoding issues by forcing UTF-8-BOM and Windows CRLF to ensure the game can read the modified JSON file correctly. Added safety check to maintain JSON array structure even with a single entry.
**mod_delete.ps1 v1.0.4**
2026-01-30: Improved: Added check for server-side deletion status (details.status) to identify and remove mods that have been hidden or deleted from CurseForge, even if their local status is still "Normal".

**mod_delete_single.ps1 v1.0.1**
2026-01-27: Fixed: Implemented UTF-8-BOM encoding and Windows CRLF line endings to prevent file corruption. Added logic to force the correct JSON array format ([]) when only one mod remains in the library.
