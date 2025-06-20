# Todo
1. "Wrong" Folder for mod_delete.log --> its in Gamepath ... should be in same folder like libray.json
2. Parameter to delete ALL Custom Cosmetics


# Changelog
**mod_delete.ps1 v1.0.1** 
2025-06-20: A display error occurred when the script was called again even though there were no mods to delete. This was due to incorrect handling of the mod_delete.log file. This file is now recreated before startup and is therefore always empty at the beginning.
