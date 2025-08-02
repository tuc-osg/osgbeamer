# Ziele der Überarbeitung 

* Stärkere Orthogonalität und höhere Flexibilität
  * [ ] Unabhängigkeit von tucbeamer (nur default)
  * [ ] evtl. ltx-talk als Backend?
  * [ ] Unabhängiges Einbinden bei möglichst vielen der Einzelpaketen
    ermöglichen
  * [ ] saubere Standalone-Lösung (sollte *ohne* OLLM funktionieren)
* [ ] zref vollständig durch hyperref ersetzen
* Möglichst viel Funktionalität aus OLLM in die Klasse.
  * [ ] Keine Macroübergabe aus OLLM, nur noch Jobname
  * [ ] Startnummern von ollmconfig.pl nach lectdates.tex
* [ ] In OLLM bleibt:
  * Generierung von Jobnamen für Wahl von
    - Dokumententyp
	- Sprache
	- Deployment
    - Nummer, aber unabhängig von Kapitelnummer (nur für Ordnung)
* Modularisierung - möglichst auch allein nutzbar:
    - Formatierungen
	- Terminal
	- Code
	- Zweisprachigkeit

## Serien-Mode (OLLM-Mode)
- Aus `ollmconfig.pl` verschwindet
   - [ ] firstchapter => wird von der Klasse festgestellt und entweder
     über lokale Datei für Deployment kommuniziert oder aus dem log
     gelesen.
   - [ ] shell_escape? => wird u.a. für lua-lfs gebraucht?
## Standalone
- Sollte möglicht viel der Series-Funktionalität haben, außer
   - Crossreferenzen
   - Cross-Literaturreferenzen
- Entscheidungsbaum für Standalone:
   - ollm standalone oder standalone-Klassoption => standalone-Modus
   - Prüfung der Directory-Stuktur/Configuration, wenn nicht ausreichend => Fehlermeldung 
   - sonst OLLM-Modus

## Designideen
- Ollm (latexmk-Mode) setzt nur den Jobnamen.
  - Optionen zur Unterdrückung des Toppic-Sufixes => leichtere spätere
    Automatisierung
  - Auslassung der Nummer für Gesamtdokument => Wie?
