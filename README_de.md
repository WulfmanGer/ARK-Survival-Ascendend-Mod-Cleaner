# ARK: Survival Ascended – Mod Remover Script 🇩🇪 

🧹 PowerShell-Skript zum Aufräumen serverseitig installierter Mods aus der `library.json` des Spiels **ARK: Survival Ascended**. Es werden keine Custom Cosmetics gelöscht! Hintergrund ist das defekte Mods die nicht mehr benötigt sind, ggf. trotzdem probleme verursachen können. Bei mir war es der "Unsichtbares Inventar"-Bug. Serverseitige Mods werden neu geladen, wenn man einen Server mit den entsprechenden Mods betritt. 

---

## Was macht das Skript?

Dieses PowerShell-Skript:

1. Erstellt ein Backup der Datei `library.json` (hier stehen alle Mods drin)
2. Erstellt ein Backup des Mod-Verzeichnisses
3. Listet alle Mods auf, **die keine Custom Cosmetics** sind
4. Schreibt diese Liste in eine Log-Datei (`mod_delete.log`)
5. Fragt dich, ob du diese Mods entfernen willst (aus der library.json und aus dem Mod-Ordner)
6. Zeigt am Ende Pfade zu den Backups für eine manuelle Kontrolle

---

## 🛠️ Nutzung

### Voraussetzungen

- Windows mit PowerShell
- Schreibrechte im ARK-Verzeichnis

### Anleitung

1. Lade die Datei `mod_cleaner.ps1` herunter
2. Öffne sie in einem Texteditor
3. Trage deinen Installationspfad zu ARK Survival Ascended ein:

```powershell
$gamePath = "G:\Spiele\Steam\steamapps\common\ARK Survival Ascended"
