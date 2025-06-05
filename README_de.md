# ARK: Survival Ascended – Mod Cleaner Script 🇩🇪 

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

1. Lade die Datei `mod_cleaner.ps1` herunter (siehe unten)
2. Öffne sie in einem Texteditor
3. Trage deinen Installationspfad zu ARK Survival Ascended ein:

```powershell
$gamePath = "G:\Spiele\Steam\steamapps\common\ARK Survival Ascended"
```
4. Starte das Script: Öffne den Dateiexplorer mit dem Ordner wo die mod_delete.ps1 von dir gespeichert wurde. Drücke UMSCHALT+Maus-Rechtsklick -> wähle Powershell-Fenster hier öffnen aus. Starte das script mit .\mod_delete.ps1


### PowerShell-Skript von GitHub herunterladen
1. Öffne das Skript auf GitHub (z. B. mod_cleaner.ps1)
2. Klicke oben rechts auf „Raw“
3. Jetzt zeigt dein Browser nur den Skriptinhalt an.
4. Rechtsklick → „Speichern unter…“
→ Achte darauf, dass die Datei als .ps1 gespeichert wird (nicht .txt oder .html)
