# BC-Entwicklungsablauf

## Branch
- Der Arbeits-Branch (`issue-<nr>` bzw. der PR-Branch) ist vom Workflow bereits ausgecheckt.
  Keine neuen Branches anlegen, nach jedem Arbeitsschritt committen und `git push -u origin HEAD`.

## Werkzeuge (MCP)
- `bc-code-intel`: AL-Best-Practices, Patterns, Code-Review – vor größeren Änderungen konsultieren.
- `bc-observatory` und `ms-learn`: BC-Doku, Objekt-/Event-Namen, Release-Infos nachschlagen statt raten.
- `azure-devops`: Work Items und Repos in Azure DevOps (Org `dynamic-difference`).

## Modus: Konzeption (Schlüsselwort „konzeptionieren“ / „Konzept“)
- NICHT programmieren, nichts deployen.
- Analysiere die Anforderung (bestehenden Code, BC-Standard per MCP nachschlagen) und schreibe das Konzept nach
  `docs/konzepte/issue-<nr>.md`, Gliederung:
  1. Ausgangslage & Ziel  2. Betroffene Objekte (Tabelle: Typ, ID, Name, neu/Erweiterung, Änderung)
  3. Ablauf als Mermaid-Diagramm (`flowchart` oder `sequenceDiagram`), Datenmodell als `erDiagram` falls Tabellen betroffen
  4. UI-Änderungen (welche Seite, welche Felder/Aktionen, wo)  5. Berechtigungen, Upgrade/Datenmigration
  6. Tests (welche Logik wird wie automatisiert getestet)  7. Offene Fragen
  8. Aufwandsschätzung: Story Points (Fibonacci) UND Personenstunden für eine:n erfahrene:n BC-Entwickler:in
     ohne KI, aufgeschlüsselt nach Konzeption/Entwicklung/Tests/Übersetzung/Review; Annahmen nennen
- Committen, pushen und im Issue eine Zusammenfassung inkl. Mermaid-Diagramm posten (GitHub rendert es)
  plus Link auf die Datei im Branch. Abschließen mit: „Freigabe mit `@claude Entwicklung freigegeben`“.
- Bei Freigabe: Konzept aus `docs/konzepte/issue-<nr>.md` umsetzen und normal weiter (Bauen und Deployen).
  Abweichungen vom Konzept im Konzept-Dokument nachtragen.

## Qualitätsregeln (gelten immer)
- Übersetzungen: `app.json` → `"features"` enthält `"TranslationFile"`. Alle Captions/Labels/ToolTips auf Englisch,
  nach dem Kompilieren `Translations/<App>.g.xlf` nach `Translations/<App>.de-DE.xlf` synchronisieren:
  jede trans-unit vorhanden, `target` mit deutscher Übersetzung (state="translated"), keine veralteten Units.
  Labels mit Platzhaltern bekommen `Comment` mit Erklärung. Fehlende Übersetzungen = Aufgabe nicht fertig.
- Automatische Tests: Jede Geschäftslogik (Codeunits, Validierungen, Event-Subscriber, Berechnungen) bekommt Tests
  in einer eigenen Test-App unter `test/` (eigenes `app.json`, Abhängigkeit auf die Haupt-App sowie
  `Library Assert`, `Any`, `Library Variable Storage`, `Tests-TestLibraries` von Microsoft; eigener idRange 50150–50199).
  Given-When-Then-Struktur, `[Test]`-Prozeduren, Handler für UI. Reine UI-Erweiterungen ohne Logik brauchen keine Tests.
  Test-App mit kompilieren und deployen; Tests mit `al runtests` ausführen, falls das scheitert,
  im Issue melden, wie die Tests in der Sandbox (Seite „AL-Testtool“) manuell gestartet werden.
- In der Rückmeldung im Issue immer angeben: Übersetzungen ✅/❌, Tests (Anzahl, Ergebnis).

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
