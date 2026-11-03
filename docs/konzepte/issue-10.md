# Konzept Issue #10 – Kundenklassifizierung (A/B/C)

Repo: `Schulungen/_git/DiFFerence.JSChart` (Azure DevOps), App-Ordner `app/`, idRange 50400–50409, Prefix `DIF`.

## 1. Ausgangslage & Ziel
Die App enthält bisher nur eine Chart-Page, keine Tabellen-/Page-Erweiterungen. Gewünscht:
- Neues Feld **„Kundenklassifizierung“** (A/B/C) auf der Debitorenkarte.
- Anzeige in der Debitorenliste.
- Beim Anlegen eines Verkaufsauftrags wird der Wert in den Auftragskopf übernommen.

## 2. Betroffene Objekte
| Typ | ID | Name | neu/Erweiterung | Änderung |
|---|---|---|---|---|
| Enum | 50400 | `DIF Customer Classification` | neu | Werte ` ` (leer), A, B, C; `Extensible = true` |
| TableExtension | 50400 | `DIF Customer Ext` (Tab 18 Customer) | Erweiterung | Feld 50400 `DIF Customer Classification` |
| TableExtension | 50401 | `DIF Sales Header Ext` (Tab 36 Sales Header) | Erweiterung | Feld 50400 `DIF Customer Classification` |
| PageExtension | 50400 | `DIF Customer Card Ext` (Page 21) | Erweiterung | Feld nach „Customer Posting Group“-Bereich (General) |
| PageExtension | 50401 | `DIF Customer List Ext` (Page 22) | Erweiterung | Feld als Spalte, per Default sichtbar |
| PageExtension | 50402 | `DIF Sales Order Ext` (Page 42) | Erweiterung | Feld im Auftragskopf (General), Anzeige |
| Codeunit | 50402 | `DIF Customer Classification Mgt` | neu | Subscriber: Übernahme Debitor → Verkaufskopf |
| PermissionSet | 50400 | `DIFALLPermission` | Erweiterung | Rechte auf neue Objekte |
| Test-App | 50150–50199 | `test/` | neu | siehe Abschnitt 6 |

Entscheidung: **Enum statt Option**, damit erweiterbar und sauber übersetzbar. Leerer Wert erlaubt (Bestandsdebitoren).
Der Wert im Verkaufskopf wird als **Kopie** gespeichert (Snapshot zum Zeitpunkt der Erstellung), nicht als FlowField.

## 3. Ablauf
```mermaid
sequenceDiagram
    actor U as Benutzer
    participant C as Debitorenkarte (21)
    participant S as Verkaufsauftrag (42)
    participant T as Sales Header (36)
    participant M as DIF Customer Classification Mgt
    U->>C: Klassifizierung A/B/C setzen
    C->>C: speichert in Customer."DIF Customer Classification"
    U->>S: Neuer Auftrag, Debitor wählen
    S->>T: Validate("Sell-to Customer No.")
    T->>M: OnAfterValidateEvent (Sell-to Customer No.)
    M->>M: Customer lesen
    M->>T: "DIF Customer Classification" := Customer-Wert
    T-->>S: Feld im Kopf angezeigt
```
Datenmodell:
```mermaid
erDiagram
    Customer ||--o{ "Sales Header" : "Sell-to Customer No."
    Customer { enum DIF_Customer_Classification }
    "Sales Header" { enum DIF_Customer_Classification }
```
Hinweis: Bei Wechsel des Debitors im bestehenden Auftrag wird der Wert neu übernommen. Nachträgliche Änderung der Debitorenklassifizierung ändert bestehende Aufträge **nicht**.

## 4. UI-Änderungen
- **Debitorenkarte (21):** Feld „Customer Classification“ im Tab „General“, editierbar, ToolTip.
- **Debitorenliste (22):** Spalte „Customer Classification“, sichtbar, ToolTip.
- **Verkaufsauftrag (42):** Feld im Tab „General“, im Kopf; Editierbar bleibt (manuelle Übersteuerung möglich) – siehe offene Fragen.
- Alle Captions/ToolTips Englisch; deutsch: „Kundenklassifizierung“.

## 5. Berechtigungen, Upgrade/Datenmigration
- `DIFALLPermission`: Rechte für Enum/Tabellenerweiterungen/Codeunit (Tabellendaten-Erweiterungen erben die Rechte auf Customer/Sales Header).
- Kein Upgrade-Code nötig: Neues Feld, Default leer. Bestehende Aufträge bleiben leer.
- Es wird kein Abhängigkeitseintrag in `app.json` benötigt (nur Base Application).

## 6. Tests
Test-App `test/` (Abhängigkeiten: Haupt-App, Library Assert, Any, Library Variable Storage, Tests-TestLibraries; idRange 50150–50199). Given-When-Then:
1. Debitor mit Klassifizierung B → neuer Verkaufsauftrag → Kopf enthält B.
2. Debitor ohne Klassifizierung → Kopf leer.
3. Debitor im bestehenden Auftrag wechseln (A → C) → Kopf zeigt C.
4. Klassifizierung am Debitor nachträglich ändern → bestehender Auftrag unverändert.
5. Alle Enum-Werte (A/B/C) werden korrekt gespeichert.
Reine UI-Erweiterungen (Pages) ohne Logik: keine Tests. Ausführung per `al runtests`, sonst manuell über „AL-Testtool“.

## 7. Offene Fragen (beantwortet)
1. Feld im Verkaufsauftrag: **editierbar**.
2. Alle **ungebuchten** Belegarten (Sales Header allgemein); **keine** gebuchten Belege.
3. Leerer Wert **zulässig**.
4. Nur Sell-to; keine abweichende Bill-to-Klassifizierung.
5. Event: `OnAfterValidateEvent` auf `Sell-to Customer No.` (Verifikation bei Umsetzung per bc-observatory).

## 8. Aufwandsschätzung
**Story Points: 3**

| Phase | Stunden |
|---|---|
| Konzeption | 1,0 |
| Entwicklung (Enum, 2 TableExt, 3 PageExt, Codeunit, Permissions) | 2,5 |
| Tests (Test-App anlegen, 5 Tests) | 2,5 |
| Übersetzung (de-DE xlf) | 0,5 |
| Review/Abnahme/Deploy | 1,0 |
| **Summe** | **7,5 h** |

Annahmen: erfahrene:r BC-Entwickler:in ohne KI, Sandbox verfügbar, Standardverhalten laut offenen Fragen (Annahmen oben), keine Übernahme in gebuchte Belege.

## 9. Umsetzung – Abweichungen vom Konzept
- Codeunit 50402 heißt `DIF Customer Class Mgt` (Objektname max. 30 Zeichen).
- Felder stehen hinter „Name“ (Karte, Liste) bzw. „Sell-to Customer Name“ (Auftrag).
- Test-App ohne Abhängigkeit auf `Tests-TestLibraries` (in der Sandbox nicht veröffentlicht); Testdaten werden direkt angelegt. 5 Tests in Codeunit 50150.
- Berechtigung: Execute auf die Codeunit; Tabellenfelder erben die Rechte der Basistabellen.
