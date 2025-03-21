# Ziele der Überarbeitung 

* Stärkere Orthogonalität und höhere Flexibilität
  * [ ] Unabhängigkeit von tucbeamer (nur default)
  * [ ] Unabhängiges Einbinden bei möglichst vielen der Einzelpaketen
    ermöglichen
  * [ ] saubere Standalone-Lösung (sollte *ohne* OLLM funktionieren)
* [ ] zref vollständig durch hyperref ersetzen
* Möglichst viel Funktionalität aus OLLM in die Klasse.
  * [ ] Startnummern von ollmconfig.pl nach lectdates.tex
* In OLLM bleibt:
  * Generierung von Jobnamen für Wahl von
    - Dokumententyp
	- Sprache
	  
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
	  


