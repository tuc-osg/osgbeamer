-- osglecture/config-integ.lua — zentrale Integrations-Tests

-- Testquellen
testfiledir = "testfiles-integ"
testsuppdir = "testfiles-integ/support"

-- Engines für Integration
stdengine    = "luatex"             -- primär lualatex
checkengines = { "luatex", "pdftex" }  -- manche Packages auch pdflatex

-- Stabilität
checkruns   = 2
checksearch = true
