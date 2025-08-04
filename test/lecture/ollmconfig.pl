# Version
$ollmver=0.12.0
####################################################################################
## Vorlesungsdaten / Jobname
####################################################################################

## Kürzelprefix der Veranstaltung (default: 'lecture')
$lectureprefix='dummy';

## Default-Sprache
#  Sprache, wenn keine lang-Option übergeben wird (default: 'de')
$defaultlanguage = 'en';

## 1 unterdrückt die Nutzung des (im Verzeichnisnamen angegebenen) Topics im Jobnamen.
# Dies macht Automatisierungen einfacher, erschwert aber die inhaltliche Übersicht.
$notopic = 0;

####################################################################################
## TeX-Suchpfade
## Relative Pfade müssen sich auf das Verzeichnis beziehen, in dem die Übersetzung
## stattfindet, NICHT auf diese (config.pl) Datei
## Ein abschließender Doppelslash ('//') schließt alle Unterverzeichnisse ein.

## Pfad der TeX-Konfigurationsdatei ohne Suffix (default: 'lectdates')
#$lectconfig='../Include/lectdates';

## Pfad zu OSG Class-File und Style-Files (kein default, kann auskommentiert
## werden, wenn im osglecture System installiert ist)
#$osgbeamer_dir = '../../../Common/TeX/osglecture//';

## Pfad zu gemeinsamen Quellen der Vorlesung (default: '../Include')
#$shared_source_dir = '../Include';

####################################################################################
## Deployment
## Für jede der vier Dokumentarten "slides" (beamer), "handout", "screen" und
## "script" (article) können ein oder mehrere Pfade (dann kommasepariert in eckigen
## Klammern) angegeben werden, in die die fertigen Dokumente kopiert werden.
## Typ 'all' steht dabei für alle Typen, was benutzt wird, wenn keine spezifischen
## Angaben für einen Dokumententyp gemacht werden.
  
$deploy_path{slides} = ['../../_Presentation/'];
$deploy_path{handout} = '/Volumes/www/osg_website/lehre/ezs/';
$deploy_path{script} = '/Volumes/www/osg_website/lehre/ezs/';

## Mit Hilfe der %deploy_file{type}-Variablen können die Zieldateinamen festgelegt werden.
## Type 'all' steht dabei wieder für alle Typen
## Für den Namen stehen folgende Template-Elemente zur Verfügung:
##  - ${prefix}:  $lectureprefix (siehe oben)
##  - ${num}:     laufende Nummer
##  - ${doctype}: Dokumententyp ('slides','handout','screen','script')
##  - ${lang}:    Kürzel für Sprache ('en' oder 'de')
##  - ${topic}:   Thema = Textteil des Verzeichnis'

$deploy_file{beamer} = '${prefix}-${num}-${doctype}-${topic}-${lang}';
$deploy_file{script} = 'Dummy-${num}_${lang}';
#$deploy_file{'dummy-script-de'} = 'dummy-script';

