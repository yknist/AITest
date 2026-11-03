# BC-Entwicklungsablauf
- Arbeite immer auf Branch `issue-<nr>`; falls er existiert, darauf weitermachen.
- Symbole: `bash scripts/bc.sh symbols`
- Kompilieren: `al compile /project:. /packagecachepath:.alpackages` – Fehler und Warnungen beheben.
- Deploy: `bash scripts/bc.sh publish <erzeugte .app>` (nur Sandbox!)
- Danach Branch pushen und im Issue melden: „✅ In Sandbox deployed – bitte testen“ plus kurze Testanleitung. Dann STOPP – keinen PR anlegen.
- PR nur, wenn der Nutzer ausdrücklich „ok“ / „PR anlegen“ schreibt.
- `.alpackages/` und `*.app` nie committen (.gitignore).