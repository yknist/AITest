# BC-Entwicklungsablauf

## Branch
- Der Arbeits-Branch (`issue-<nr>` bzw. der PR-Branch) ist vom Workflow bereits ausgecheckt.
  Keine neuen Branches anlegen, nach jedem Arbeitsschritt committen und `git push -u origin HEAD`.

## Werkzeuge (MCP)
- `bc-code-intel`: AL-Best-Practices, Patterns, Code-Review – vor größeren Änderungen konsultieren.
- `bc-observatory` und `ms-learn`: BC-Doku, Objekt-/Event-Namen, Release-Infos nachschlagen statt raten.
- `azure-devops`: Work Items und Repos in Azure DevOps (Org `dynamic-difference`).

## Bauen und Deployen
- Symbole: `bash Scripts/bc.sh symbols`
- Kompilieren: `al compile /project:. /packagecachepath:.alpackages` – Fehler und Warnungen beheben.
  Falls die Syntax nicht passt: `al compile --help` aufrufen und anpassen.
- Deploy: `bash Scripts/bc.sh publish <erzeugte .app>` (nur Sandbox!)
- Gibt es noch kein `app.json`, lege ein neues AL-Projekt an (neue GUID als `id`, Publisher `yknist`,
  `idRanges` 50100–50149, `platform`/`application` passend zur Sandbox-Version) und lade dann die Symbole.
- `.alpackages/` und `*.app` nie committen (.gitignore).

## Rückmeldung
- Nach erfolgreichem Deploy im Issue melden: „✅ In Sandbox deployed – bitte testen“ plus kurze Testanleitung.
  Dann STOPP – keinen PR anlegen.
- Bei Fehlern, die du nicht selbst lösen kannst: im Issue kurz Ursache und benötigte Aktion des Nutzers nennen.
- PR nur, wenn der Nutzer ausdrücklich „ok“ / „PR anlegen“ schreibt:
  `gh pr create --base main --head <branch> --title "..." --body "Closes #<nr> ..."`
