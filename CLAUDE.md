# BC-Entwicklungsablauf
- Die Action legt pro Lauf einen neuen Branch `claude/issue-<nr>-<zeitstempel>` an. Gibt es schon einen älteren
  Branch `claude/issue-<nr>-*`, zuerst dessen neuesten Stand in den aktuellen Branch mergen und darauf weiterarbeiten.
- Symbole: `bash Scripts/bc.sh symbols`
- Kompilieren: `al compile /project:. /packagecachepath:.alpackages` – Fehler und Warnungen beheben.
  Falls die Syntax nicht passt: `al help compile` aufrufen und anpassen.
- Deploy: `bash Scripts/bc.sh publish <erzeugte .app>` (nur Sandbox!)
- Danach Branch pushen und im Issue melden: „✅ In Sandbox deployed – bitte testen“ plus kurze Testanleitung. Dann STOPP – keinen PR anlegen.
- PR nur, wenn der Nutzer ausdrücklich „ok“ / „PR anlegen“ schreibt.
- `.alpackages/` und `*.app` nie committen (.gitignore).
- Gibt es noch kein `app.json`, lege ein neues AL-Projekt an (neue GUID als `id`, Publisher `yknist`,
  `idRanges` 50100–50149, `platform`/`application` passend zur Sandbox-Version) und lade dann die Symbole.
