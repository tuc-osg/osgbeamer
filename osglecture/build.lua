-- Modul: osglecture (Klasse + begleitende Styles)

module = "osglecture"

-- Quellen dieses Moduls
sourcefiles  = {
  "osglecture.dtx",
  "osglecture.ins",
  "doc/osglecture-doc.tex",
  "styles/*.sty",           -- Styles, die zur Klasse gehören
}

typesetfiles = { "doc/osglecture-doc.tex" }

-- Nur dieses Modul testet standardmäßig mit lualatex (Unit)
stdengine    = "luatex"
checkengines = { "luatex" }

-- Doku braucht ggf. die eigenen Styles
supportfiles = { "styles/*.sty" }

-- Falls du Bilder/Beispiele in der Doku hast:
-- docfiles = { "doc/examples/*.*" }
