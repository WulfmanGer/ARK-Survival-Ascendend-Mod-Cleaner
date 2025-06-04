# ARK: Survival Ascended – Mod Remover Script

🧹 PowerShell-Skript zum Aufräumen serverseitig installierter Mods aus der `library.json` des Spiels **ARK: Survival Ascended**. Es werden keine Custom Cosmetics gelöscht!

---

## 🇩🇪 Was macht das Skript?

Dieses PowerShell-Skript:

1. Erstellt ein Backup der Datei `library.json`
2. Erstellt ein Backup des Mod-Verzeichnisses
3. Listet alle Mods auf, **die keine Custom Cosmetics (Kategorie-ID 6844)** sind
4. Schreibt diese Liste in eine Log-Datei (`mod_delete.log`)
5. Fragt dich, ob du diese Mods aus der JSON entfernen willst
6. Löscht anschließend die zugehörigen Mod-Ordner
7. Zeigt am Ende Pfade zu den Backups für eine manuelle Kontrolle

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
