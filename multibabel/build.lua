module = "multibabel"


-- Script-Auslieferung (landet in TEXMF/scripts/osglecture/)
scriptfiles = {
  "scripts/ollm",
  "scripts/ollm.bat",   -- optional; für Windows bequem
}

sourcefiles  = { "multibabel.dtx"}
unpackfiles  = { "multibabel.dtx" }
unpackexe    = "tex"
typesetfiles = { "multibabel.tex" }
installfiles = { "multibabel.sty" }

