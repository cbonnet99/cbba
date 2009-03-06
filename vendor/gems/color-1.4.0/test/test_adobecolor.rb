#!/usr/bin/env ruby
#--
# Color
# Colour management with Ruby
# http://rubyforge.org/projects/color
#   Version 1.4.0
#
# Licensed under a MIT-style licence. See Licence.txt in the main
# distribution for full licensing information.
#
# Copyright (c) 2005 - 2007 Austin Ziegler and Matt Lyon
#
# $Id: test_all.rb 55 2007-02-03 23:29:34Z austin $
#++

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib") if __FILE__ == $0
require 'test/unit'
require 'color'
require 'color/palette/adobecolor'

module TestColor
  module TestPalette
    class TestAdobeColor < Test::Unit::TestCase
      include Color::Palette

      # This is based on the Visibone Anglo-Centric Color Code List; this is
      # an Adobe Color swatch version 1 (RGB colours only).
      VISIBONE_V1 = <<-EOS
AAEA2AAA/wD/AP8AAAAAAMwAzADMAAAAAACZAJkAmQAAAAAAZgBmAGYAAAAA
ADMAMwAzAAAAAAAAAAAAAAAAAAAA/wAAAAAAAAAAAP8AMwAzAAAAAADMAAAA
AAAAAAAA/wBmAGYAAAAAAMwAMwAzAAAAAACZAAAAAAAAAAAA/wCZAJkAAAAA
AMwAZgBmAAAAAACZADMAMwAAAAAAZgAAAAAAAAAAAP8AzADMAAAAAADMAJkA
mQAAAAAAmQBmAGYAAAAAAGYAMwAzAAAAAAAzAAAAAAAAAAAA/wAzAAAAAAAA
AP8AZgAzAAAAAADMADMAAAAAAAAA/wCZAGYAAAAAAMwAZgAzAAAAAACZADMA
AAAAAAAA/wBmAAAAAAAAAP8AmQAzAAAAAADMAGYAAAAAAAAA/wDMAJkAAAAA
AMwAmQBmAAAAAACZAGYAMwAAAAAAZgAzAAAAAAAAAP8AmQAAAAAAAAD/AMwA
ZgAAAAAAzACZADMAAAAAAJkAZgAAAAAAAADMAJkAAAAAAAAA/wDMADMAAAAA
AP8AzAAAAAAAAAD/AP8AAAAAAAAA/wD/ADMAAAAAAMwAzAAAAAAAAAD/AP8A
ZgAAAAAAzADMADMAAAAAAJkAmQAAAAAAAAD/AP8AmQAAAAAAzADMAGYAAAAA
AJkAmQAzAAAAAABmAGYAAAAAAAAA/wD/AMwAAAAAAMwAzACZAAAAAACZAJkA
ZgAAAAAAZgBmADMAAAAAADMAMwAAAAAAAADMAP8AAAAAAAAAzAD/ADMAAAAA
AJkAzAAAAAAAAADMAP8AZgAAAAAAmQDMADMAAAAAAGYAmQAAAAAAAACZAP8A
AAAAAAAAmQD/ADMAAAAAAGYAzAAAAAAAAADMAP8AmQAAAAAAmQDMAGYAAAAA
AGYAmQAzAAAAAAAzAGYAAAAAAAAAZgD/AAAAAAAAAJkA/wBmAAAAAABmAMwA
MwAAAAAAMwCZAAAAAAAAAGYA/wAzAAAAAAAzAMwAAAAAAAAAMwD/AAAAAAAA
AAAA/wAAAAAAAAAzAP8AMwAAAAAAAADMAAAAAAAAAGYA/wBmAAAAAAAzAMwA
MwAAAAAAAACZAAAAAAAAAJkA/wCZAAAAAABmAMwAZgAAAAAAMwCZADMAAAAA
AAAAZgAAAAAAAADMAP8AzAAAAAAAmQDMAJkAAAAAAGYAmQBmAAAAAAAzAGYA
MwAAAAAAAAAzAAAAAAAAAAAA/wAzAAAAAAAzAP8AZgAAAAAAAADMADMAAAAA
AGYA/wCZAAAAAAAzAMwAZgAAAAAAAACZADMAAAAAAAAA/wBmAAAAAAAzAP8A
mQAAAAAAAADMAGYAAAAAAJkA/wDMAAAAAABmAMwAmQAAAAAAMwCZAGYAAAAA
AAAAZgAzAAAAAAAAAP8AmQAAAAAAZgD/AMwAAAAAADMAzACZAAAAAAAAAJkA
ZgAAAAAAMwD/AMwAAAAAAAAAzACZAAAAAAAAAP8AzAAAAAAAAAD/AP8AAAAA
ADMA/wD/AAAAAAAAAMwAzAAAAAAAZgD/AP8AAAAAADMAzADMAAAAAAAAAJkA
mQAAAAAAmQD/AP8AAAAAAGYAzADMAAAAAAAzAJkAmQAAAAAAAABmAGYAAAAA
AMwA/wD/AAAAAACZAMwAzAAAAAAAZgCZAJkAAAAAADMAZgBmAAAAAAAAADMA
MwAAAAAAAADMAP8AAAAAADMAzAD/AAAAAAAAAJkAzAAAAAAAZgDMAP8AAAAA
ADMAmQDMAAAAAAAAAGYAmQAAAAAAAACZAP8AAAAAADMAmQD/AAAAAAAAAGYA
zAAAAAAAmQDMAP8AAAAAAGYAmQDMAAAAAAAzAGYAmQAAAAAAAAAzAGYAAAAA
AAAAZgD/AAAAAABmAJkA/wAAAAAAMwBmAMwAAAAAAAAAMwCZAAAAAAAzAGYA
/wAAAAAAAAAzAMwAAAAAAAAAMwD/AAAAAAAAAAAA/wAAAAAAMwAzAP8AAAAA
AAAAAADMAAAAAABmAGYA/wAAAAAAMwAzAMwAAAAAAAAAAACZAAAAAACZAJkA
/wAAAAAAZgBmAMwAAAAAADMAMwCZAAAAAAAAAAAAZgAAAAAAzADMAP8AAAAA
AJkAmQDMAAAAAABmAGYAmQAAAAAAMwAzAGYAAAAAAAAAAAAzAAAAAAAzAAAA
/wAAAAAAZgAzAP8AAAAAADMAAADMAAAAAACZAGYA/wAAAAAAZgAzAMwAAAAA
ADMAAACZAAAAAABmAAAA/wAAAAAAmQAzAP8AAAAAAGYAAADMAAAAAADMAJkA
/wAAAAAAmQBmAMwAAAAAAGYAMwCZAAAAAAAzAAAAZgAAAAAAmQAAAP8AAAAA
AMwAZgD/AAAAAACZADMAzAAAAAAAZgAAAJkAAAAAAMwAMwD/AAAAAACZAAAA
zAAAAAAAzAAAAP8AAAAAAP8AAAD/AAAAAAD/ADMA/wAAAAAAzAAAAMwAAAAA
AP8AZgD/AAAAAADMADMAzAAAAAAAmQAAAJkAAAAAAP8AmQD/AAAAAADMAGYA
zAAAAAAAmQAzAJkAAAAAAGYAAABmAAAAAAD/AMwA/wAAAAAAzACZAMwAAAAA
AJkAZgCZAAAAAABmADMAZgAAAAAAMwAAADMAAAAAAP8AAADMAAAAAAD/ADMA
zAAAAAAAzAAAAJkAAAAAAP8AZgDMAAAAAADMADMAmQAAAAAAmQAAAGYAAAAA
AP8AAACZAAAAAAD/ADMAmQAAAAAAzAAAAGYAAAAAAP8AmQDMAAAAAADMAGYA
mQAAAAAAmQAzAGYAAAAAAGYAAAAzAAAAAAD/AAAAZgAAAAAA/wBmAJkAAAAA
AMwAMwBmAAAAAACZAAAAMwAAAAAA/wAzAGYAAAAAAMwAAAAzAAAAAAD/AAAA
MwAAAA==
      EOS

      # This is based on the Visibone Anglo-Centric Color Code List; this is
      # an Adobe Color swatch version 2 (with names).
      VISIBONE_V2 = <<-EOS
AAIA2AAA/wD/AP8AAAAAAAAGAFcAaABpAHQAZQAAAADMAMwAzAAAAAAAAAoA
UABhAGwAZQAgAEcAcgBhAHkAAAAAmQCZAJkAAAAAAAALAEwAaQBnAGgAdAAg
AEcAcgBhAHkAAAAAZgBmAGYAAAAAAAAKAEQAYQByAGsAIABHAHIAYQB5AAAA
ADMAMwAzAAAAAAAADQBPAGIAcwBjAHUAcgBlACAARwByAGEAeQAAAAAAAAAA
AAAAAAAAAAYAQgBsAGEAYwBrAAAAAP8AAAAAAAAAAAAABABSAGUAZAAAAAD/
ADMAMwAAAAAAAA8ATABpAGcAaAB0ACAASABhAHIAZAAgAFIAZQBkAAAAAMwA
AAAAAAAAAAAADgBEAGEAcgBrACAASABhAHIAZAAgAFIAZQBkAAAAAP8AZgBm
AAAAAAAAEABMAGkAZwBoAHQAIABGAGEAZABlAGQAIABSAGUAZAAAAADMADMA
MwAAAAAAABEATQBlAGQAaQB1AG0AIABGAGEAZABlAGQAIABSAGUAZAAAAACZ
AAAAAAAAAAAAAA8ARABhAHIAawAgAEYAYQBkAGUAZAAgAFIAZQBkAAAAAP8A
mQCZAAAAAAAADgBQAGEAbABlACAARAB1AGwAbAAgAFIAZQBkAAAAAMwAZgBm
AAAAAAAADwBMAGkAZwBoAHQAIABEAHUAbABsACAAUgBlAGQAAAAAmQAzADMA
AAAAAAAOAEQAYQByAGsAIABEAHUAbABsACAAUgBlAGQAAAAAZgAAAAAAAAAA
AAARAE8AYgBzAGMAdQByAGUAIABEAHUAbABsACAAUgBlAGQAAAAA/wDMAMwA
AAAAAAAOAFAAYQBsAGUAIABXAGUAYQBrACAAUgBlAGQAAAAAzACZAJkAAAAA
AAAPAEwAaQBnAGgAdAAgAFcAZQBhAGsAIABSAGUAZAAAAACZAGYAZgAAAAAA
ABAATQBlAGQAaQB1AG0AIABXAGUAYQBrACAAUgBlAGQAAAAAZgAzADMAAAAA
AAAOAEQAYQByAGsAIABXAGUAYQBrACAAUgBlAGQAAAAAMwAAAAAAAAAAAAAR
AE8AYgBzAGMAdQByAGUAIABXAGUAYQBrACAAUgBlAGQAAAAA/wAzAAAAAAAA
AAAPAFIAZQBkAC0AUgBlAGQALQBPAHIAYQBuAGcAZQAAAAD/AGYAMwAAAAAA
ABEATABpAGcAaAB0ACAAUgBlAGQALQBPAHIAYQBuAGcAZQAAAADMADMAAAAA
AAAAABAARABhAHIAawAgAFIAZQBkAC0ATwByAGEAbgBnAGUAAAAA/wCZAGYA
AAAAAAARAEwAaQBnAGgAdAAgAE8AcgBhAG4AZwBlAC0AUgBlAGQAAAAAzABm
ADMAAAAAAAASAE0AZQBkAGkAdQBtACAATwByAGEAbgBnAGUALQBSAGUAZAAA
AACZADMAAAAAAAAAABAARABhAHIAawAgAE8AcgBhAG4AZwBlAC0AUgBlAGQA
AAAA/wBmAAAAAAAAAAASAE8AcgBhAG4AZwBlAC0ATwByAGEAbgBnAGUALQBS
AGUAZAAAAAD/AJkAMwAAAAAAABIATABpAGcAaAB0ACAASABhAHIAZAAgAE8A
cgBhAG4AZwBlAAAAAMwAZgAAAAAAAAAAEQBEAGEAcgBrACAASABhAHIAZAAg
AE8AcgBhAG4AZwBlAAAAAP8AzACZAAAAAAAAEQBQAGEAbABlACAARAB1AGwA
bAAgAE8AcgBhAG4AZwBlAAAAAMwAmQBmAAAAAAAAEgBMAGkAZwBoAHQAIABE
AHUAbABsACAATwByAGEAbgBnAGUAAAAAmQBmADMAAAAAAAARAEQAYQByAGsA
IABEAHUAbABsACAATwByAGEAbgBnAGUAAAAAZgAzAAAAAAAAAAAUAE8AYgBz
AGMAdQByAGUAIABEAHUAbABsACAATwByAGEAbgBnAGUAAAAA/wCZAAAAAAAA
AAAVAE8AcgBhAG4AZwBlAC0ATwByAGEAbgBnAGUALQBZAGUAbABsAG8AdwAA
AAD/AMwAZgAAAAAAABQATABpAGcAaAB0ACAATwByAGEAbgBnAGUALQBZAGUA
bABsAG8AdwAAAADMAJkAMwAAAAAAABUATQBlAGQAaQB1AG0AIABPAHIAYQBu
AGcAZQAtAFkAZQBsAGwAbwB3AAAAAJkAZgAAAAAAAAAAEwBEAGEAcgBrACAA
TwByAGEAbgBnAGUALQBZAGUAbABsAG8AdwAAAADMAJkAAAAAAAAAABMARABh
AHIAawAgAFkAZQBsAGwAbwB3AC0ATwByAGEAbgBnAGUAAAAA/wDMADMAAAAA
AAAUAEwAaQBnAGgAdAAgAFkAZQBsAGwAbwB3AC0ATwByAGEAbgBnAGUAAAAA
/wDMAAAAAAAAAAAVAFkAZQBsAGwAbwB3AC0AWQBlAGwAbABvAHcALQBPAHIA
YQBuAGcAZQAAAAD/AP8AAAAAAAAAAAcAWQBlAGwAbABvAHcAAAAA/wD/ADMA
AAAAAAASAEwAaQBnAGgAdAAgAEgAYQByAGQAIABZAGUAbABsAG8AdwAAAADM
AMwAAAAAAAAAABEARABhAHIAawAgAEgAYQByAGQAIABZAGUAbABsAG8AdwAA
AAD/AP8AZgAAAAAAABMATABpAGcAaAB0ACAARgBhAGQAZQBkACAAWQBlAGwA
bABvAHcAAAAAzADMADMAAAAAAAAUAE0AZQBkAGkAdQBtACAARgBhAGQAZQBk
ACAAWQBlAGwAbABvAHcAAAAAmQCZAAAAAAAAAAASAEQAYQByAGsAIABGAGEA
ZABlAGQAIABZAGUAbABsAG8AdwAAAAD/AP8AmQAAAAAAABEAUABhAGwAZQAg
AEQAdQBsAGwAIABZAGUAbABsAG8AdwAAAADMAMwAZgAAAAAAABIATABpAGcA
aAB0ACAARAB1AGwAbAAgAFkAZQBsAGwAbwB3AAAAAJkAmQAzAAAAAAAAEQBE
AGEAcgBrACAARAB1AGwAbAAgAFkAZQBsAGwAbwB3AAAAAGYAZgAAAAAAAAAA
FABPAGIAcwBjAHUAcgBlACAARAB1AGwAbAAgAFkAZQBsAGwAbwB3AAAAAP8A
/wDMAAAAAAAAEQBQAGEAbABlACAAVwBlAGEAawAgAFkAZQBsAGwAbwB3AAAA
AMwAzACZAAAAAAAAEgBMAGkAZwBoAHQAIABXAGUAYQBrACAAWQBlAGwAbABv
AHcAAAAAmQCZAGYAAAAAAAATAE0AZQBkAGkAdQBtACAAVwBlAGEAawAgAFkA
ZQBsAGwAbwB3AAAAAGYAZgAzAAAAAAAAEQBEAGEAcgBrACAAVwBlAGEAawAg
AFkAZQBsAGwAbwB3AAAAADMAMwAAAAAAAAAAFABPAGIAcwBjAHUAcgBlACAA
VwBlAGEAawAgAFkAZQBsAGwAbwB3AAAAAMwA/wAAAAAAAAAAFQBZAGUAbABs
AG8AdwAtAFkAZQBsAGwAbwB3AC0AUwBwAHIAaQBuAGcAAAAAzAD/ADMAAAAA
AAAUAEwAaQBnAGgAdAAgAFkAZQBsAGwAbwB3AC0AUwBwAHIAaQBuAGcAAAAA
mQDMAAAAAAAAAAATAEQAYQByAGsAIABZAGUAbABsAG8AdwAtAFMAcAByAGkA
bgBnAAAAAMwA/wBmAAAAAAAAFABMAGkAZwBoAHQAIABTAHAAcgBpAG4AZwAt
AFkAZQBsAGwAbwB3AAAAAJkAzAAzAAAAAAAAFQBNAGUAZABpAHUAbQAgAFMA
cAByAGkAbgBnAC0AWQBlAGwAbABvAHcAAAAAZgCZAAAAAAAAAAATAEQAYQBy
AGsAIABTAHAAcgBpAG4AZwAtAFkAZQBsAGwAbwB3AAAAAJkA/wAAAAAAAAAA
FQBTAHAAcgBpAG4AZwAtAFMAcAByAGkAbgBnAC0AWQBlAGwAbABvAHcAAAAA
mQD/ADMAAAAAAAASAEwAaQBnAGgAdAAgAEgAYQByAGQAIABTAHAAcgBpAG4A
ZwAAAABmAMwAAAAAAAAAABEARABhAHIAawAgAEgAYQByAGQAIABTAHAAcgBp
AG4AZwAAAADMAP8AmQAAAAAAABEAUABhAGwAZQAgAEQAdQBsAGwAIABTAHAA
cgBpAG4AZwAAAACZAMwAZgAAAAAAABIATABpAGcAaAB0ACAARAB1AGwAbAAg
AFMAcAByAGkAbgBnAAAAAGYAmQAzAAAAAAAAEQBEAGEAcgBrACAARAB1AGwA
bAAgAFMAcAByAGkAbgBnAAAAADMAZgAAAAAAAAAAFABPAGIAcwBjAHUAcgBl
ACAARAB1AGwAbAAgAFMAcAByAGkAbgBnAAAAAGYA/wAAAAAAAAAAFABTAHAA
cgBpAG4AZwAtAFMAcAByAGkAbgBnAC0ARwByAGUAZQBuAAAAAJkA/wBmAAAA
AAAAEwBMAGkAZwBoAHQAIABTAHAAcgBpAG4AZwAtAEcAcgBlAGUAbgAAAABm
AMwAMwAAAAAAABQATQBlAGQAaQB1AG0AIABTAHAAcgBpAG4AZwAtAEcAcgBl
AGUAbgAAAAAzAJkAAAAAAAAAABIARABhAHIAawAgAFMAcAByAGkAbgBnAC0A
RwByAGUAZQBuAAAAAGYA/wAzAAAAAAAAEwBMAGkAZwBoAHQAIABHAHIAZQBl
AG4ALQBTAHAAcgBpAG4AZwAAAAAzAMwAAAAAAAAAABIARABhAHIAawAgAEcA
cgBlAGUAbgAtAFMAcAByAGkAbgBnAAAAADMA/wAAAAAAAAAAEwBHAHIAZQBl
AG4ALQBHAHIAZQBlAG4ALQBTAHAAcgBpAG4AZwAAAAAAAP8AAAAAAAAAAAYA
RwByAGUAZQBuAAAAADMA/wAzAAAAAAAAEQBMAGkAZwBoAHQAIABIAGEAcgBk
ACAARwByAGUAZQBuAAAAAAAAzAAAAAAAAAAAEABEAGEAcgBrACAASABhAHIA
ZAAgAEcAcgBlAGUAbgAAAABmAP8AZgAAAAAAABIATABpAGcAaAB0ACAARgBh
AGQAZQBkACAARwByAGUAZQBuAAAAADMAzAAzAAAAAAAAEwBNAGUAZABpAHUA
bQAgAEYAYQBkAGUAZAAgAEcAcgBlAGUAbgAAAAAAAJkAAAAAAAAAABEARABh
AHIAawAgAEYAYQBkAGUAZAAgAEcAcgBlAGUAbgAAAACZAP8AmQAAAAAAABAA
UABhAGwAZQAgAEQAdQBsAGwAIABHAHIAZQBlAG4AAAAAZgDMAGYAAAAAAAAR
AEwAaQBnAGgAdAAgAEQAdQBsAGwAIABHAHIAZQBlAG4AAAAAMwCZADMAAAAA
AAAQAEQAYQByAGsAIABEAHUAbABsACAARwByAGUAZQBuAAAAAAAAZgAAAAAA
AAAAEwBPAGIAcwBjAHUAcgBlACAARAB1AGwAbAAgAEcAcgBlAGUAbgAAAADM
AP8AzAAAAAAAABAAUABhAGwAZQAgAFcAZQBhAGsAIABHAHIAZQBlAG4AAAAA
mQDMAJkAAAAAAAARAEwAaQBnAGgAdAAgAFcAZQBhAGsAIABHAHIAZQBlAG4A
AAAAZgCZAGYAAAAAAAASAE0AZQBkAGkAdQBtACAAVwBlAGEAawAgAEcAcgBl
AGUAbgAAAAAzAGYAMwAAAAAAABAARABhAHIAawAgAFcAZQBhAGsAIABHAHIA
ZQBlAG4AAAAAAAAzAAAAAAAAAAATAE8AYgBzAGMAdQByAGUAIABXAGUAYQBr
ACAARwByAGUAZQBuAAAAAAAA/wAzAAAAAAAAEQBHAHIAZQBlAG4ALQBHAHIA
ZQBlAG4ALQBUAGUAYQBsAAAAADMA/wBmAAAAAAAAEQBMAGkAZwBoAHQAIABH
AHIAZQBlAG4ALQBUAGUAYQBsAAAAAAAAzAAzAAAAAAAAEABEAGEAcgBrACAA
RwByAGUAZQBuAC0AVABlAGEAbAAAAABmAP8AmQAAAAAAABEATABpAGcAaAB0
ACAAVABlAGEAbAAtAEcAcgBlAGUAbgAAAAAzAMwAZgAAAAAAABIATQBlAGQA
aQB1AG0AIABUAGUAYQBsAC0ARwByAGUAZQBuAAAAAAAAmQAzAAAAAAAAEABE
AGEAcgBrACAAVABlAGEAbAAtAEcAcgBlAGUAbgAAAAAAAP8AZgAAAAAAABAA
VABlAGEAbAAtAFQAZQBhAGwALQBHAHIAZQBlAG4AAAAAMwD/AJkAAAAAAAAQ
AEwAaQBnAGgAdAAgAEgAYQByAGQAIABUAGUAYQBsAAAAAAAAzABmAAAAAAAA
DwBEAGEAcgBrACAASABhAHIAZAAgAFQAZQBhAGwAAAAAmQD/AMwAAAAAAAAP
AFAAYQBsAGUAIABEAHUAbABsACAAVABlAGEAbAAAAABmAMwAmQAAAAAAABAA
TABpAGcAaAB0ACAARAB1AGwAbAAgAFQAZQBhAGwAAAAAMwCZAGYAAAAAAAAP
AEQAYQByAGsAIABEAHUAbABsACAAVABlAGEAbAAAAAAAAGYAMwAAAAAAABIA
TwBiAHMAYwB1AHIAZQAgAEQAdQBsAGwAIABUAGUAYQBsAAAAAAAA/wCZAAAA
AAAADwBUAGUAYQBsAC0AVABlAGEAbAAtAEMAeQBhAG4AAAAAZgD/AMwAAAAA
AAAQAEwAaQBnAGgAdAAgAFQAZQBhAGwALQBDAHkAYQBuAAAAADMAzACZAAAA
AAAAEQBNAGUAZABpAHUAbQAgAFQAZQBhAGwALQBDAHkAYQBuAAAAAAAAmQBm
AAAAAAAADwBEAGEAcgBrACAAVABlAGEAbAAtAEMAeQBhAG4AAAAAMwD/AMwA
AAAAAAAQAEwAaQBnAGgAdAAgAEMAeQBhAG4ALQBUAGUAYQBsAAAAAAAAzACZ
AAAAAAAADwBEAGEAcgBrACAAQwB5AGEAbgAtAFQAZQBhAGwAAAAAAAD/AMwA
AAAAAAAPAEMAeQBhAG4ALQBDAHkAYQBuAC0AVABlAGEAbAAAAAAAAP8A/wAA
AAAAAAUAQwB5AGEAbgAAAAAzAP8A/wAAAAAAABAATABpAGcAaAB0ACAASABh
AHIAZAAgAEMAeQBhAG4AAAAAAADMAMwAAAAAAAAPAEQAYQByAGsAIABIAGEA
cgBkACAAQwB5AGEAbgAAAABmAP8A/wAAAAAAABEATABpAGcAaAB0ACAARgBh
AGQAZQBkACAAQwB5AGEAbgAAAAAzAMwAzAAAAAAAABIATQBlAGQAaQB1AG0A
IABGAGEAZABlAGQAIABDAHkAYQBuAAAAAAAAmQCZAAAAAAAAEABEAGEAcgBr
ACAARgBhAGQAZQBkACAAQwB5AGEAbgAAAACZAP8A/wAAAAAAAA8AUABhAGwA
ZQAgAEQAdQBsAGwAIABDAHkAYQBuAAAAAGYAzADMAAAAAAAAEABMAGkAZwBo
AHQAIABEAHUAbABsACAAQwB5AGEAbgAAAAAzAJkAmQAAAAAAAA8ARABhAHIA
awAgAEQAdQBsAGwAIABDAHkAYQBuAAAAAAAAZgBmAAAAAAAAEgBPAGIAcwBj
AHUAcgBlACAARAB1AGwAbAAgAEMAeQBhAG4AAAAAzAD/AP8AAAAAAAAPAFAA
YQBsAGUAIABXAGUAYQBrACAAQwB5AGEAbgAAAACZAMwAzAAAAAAAABAATABp
AGcAaAB0ACAAVwBlAGEAawAgAEMAeQBhAG4AAAAAZgCZAJkAAAAAAAARAE0A
ZQBkAGkAdQBtACAAVwBlAGEAawAgAEMAeQBhAG4AAAAAMwBmAGYAAAAAAAAP
AEQAYQByAGsAIABXAGUAYQBrACAAQwB5AGEAbgAAAAAAADMAMwAAAAAAABIA
TwBiAHMAYwB1AHIAZQAgAFcAZQBhAGsAIABDAHkAYQBuAAAAAAAAzAD/AAAA
AAAAEABDAHkAYQBuAC0AQwB5AGEAbgAtAEEAegB1AHIAZQAAAAAzAMwA/wAA
AAAAABEATABpAGcAaAB0ACAAQwB5AGEAbgAtAEEAegB1AHIAZQAAAAAAAJkA
zAAAAAAAABAARABhAHIAawAgAEMAeQBhAG4ALQBBAHoAdQByAGUAAAAAZgDM
AP8AAAAAAAARAEwAaQBnAGgAdAAgAEEAegB1AHIAZQAtAEMAeQBhAG4AAAAA
MwCZAMwAAAAAAAASAE0AZQBkAGkAdQBtACAAQQB6AHUAcgBlAC0AQwB5AGEA
bgAAAAAAAGYAmQAAAAAAABAARABhAHIAawAgAEEAegB1AHIAZQAtAEMAeQBh
AG4AAAAAAACZAP8AAAAAAAARAEEAegB1AHIAZQAtAEEAegB1AHIAZQAtAEMA
eQBhAG4AAAAAMwCZAP8AAAAAAAARAEwAaQBnAGgAdAAgAEgAYQByAGQAIABB
AHoAdQByAGUAAAAAAABmAMwAAAAAAAAQAEQAYQByAGsAIABIAGEAcgBkACAA
QQB6AHUAcgBlAAAAAJkAzAD/AAAAAAAAEABQAGEAbABlACAARAB1AGwAbAAg
AEEAegB1AHIAZQAAAABmAJkAzAAAAAAAABEATABpAGcAaAB0ACAARAB1AGwA
bAAgAEEAegB1AHIAZQAAAAAzAGYAmQAAAAAAABAARABhAHIAawAgAEQAdQBs
AGwAIABBAHoAdQByAGUAAAAAAAAzAGYAAAAAAAATAE8AYgBzAGMAdQByAGUA
IABEAHUAbABsACAAQQB6AHUAcgBlAAAAAAAAZgD/AAAAAAAAEQBBAHoAdQBy
AGUALQBBAHoAdQByAGUALQBCAGwAdQBlAAAAAGYAmQD/AAAAAAAAEQBMAGkA
ZwBoAHQAIABBAHoAdQByAGUALQBCAGwAdQBlAAAAADMAZgDMAAAAAAAAEgBN
AGUAZABpAHUAbQAgAEEAegB1AHIAZQAtAEIAbAB1AGUAAAAAAAAzAJkAAAAA
AAAQAEQAYQByAGsAIABBAHoAdQByAGUALQBCAGwAdQBlAAAAADMAZgD/AAAA
AAAAEQBMAGkAZwBoAHQAIABCAGwAdQBlAC0AQQB6AHUAcgBlAAAAAAAAMwDM
AAAAAAAAEABEAGEAcgBrACAAQgBsAHUAZQAtAEEAegB1AHIAZQAAAAAAADMA
/wAAAAAAABAAQgBsAHUAZQAtAEIAbAB1AGUALQBBAHoAdQByAGUAAAAAAAAA
AP8AAAAAAAAFAEIAbAB1AGUAAAAAMwAzAP8AAAAAAAAQAEwAaQBnAGgAdAAg
AEgAYQByAGQAIABCAGwAdQBlAAAAAAAAAADMAAAAAAAADwBEAGEAcgBrACAA
SABhAHIAZAAgAEIAbAB1AGUAAAAAZgBmAP8AAAAAAAARAEwAaQBnAGgAdAAg
AEYAYQBkAGUAZAAgAEIAbAB1AGUAAAAAMwAzAMwAAAAAAAASAE0AZQBkAGkA
dQBtACAARgBhAGQAZQBkACAAQgBsAHUAZQAAAAAAAAAAmQAAAAAAABAARABh
AHIAawAgAEYAYQBkAGUAZAAgAEIAbAB1AGUAAAAAmQCZAP8AAAAAAAAPAFAA
YQBsAGUAIABEAHUAbABsACAAQgBsAHUAZQAAAABmAGYAzAAAAAAAABAATABp
AGcAaAB0ACAARAB1AGwAbAAgAEIAbAB1AGUAAAAAMwAzAJkAAAAAAAAPAEQA
YQByAGsAIABEAHUAbABsACAAQgBsAHUAZQAAAAAAAAAAZgAAAAAAABIATwBi
AHMAYwB1AHIAZQAgAEQAdQBsAGwAIABCAGwAdQBlAAAAAMwAzAD/AAAAAAAA
DwBQAGEAbABlACAAVwBlAGEAawAgAEIAbAB1AGUAAAAAmQCZAMwAAAAAAAAQ
AEwAaQBnAGgAdAAgAFcAZQBhAGsAIABCAGwAdQBlAAAAAGYAZgCZAAAAAAAA
EQBNAGUAZABpAHUAbQAgAFcAZQBhAGsAIABCAGwAdQBlAAAAADMAMwBmAAAA
AAAADwBEAGEAcgBrACAAVwBlAGEAawAgAEIAbAB1AGUAAAAAAAAAADMAAAAA
AAASAE8AYgBzAGMAdQByAGUAIABXAGUAYQBrACAAQgBsAHUAZQAAAAAzAAAA
/wAAAAAAABEAQgBsAHUAZQAtAEIAbAB1AGUALQBWAGkAbwBsAGUAdAAAAABm
ADMA/wAAAAAAABIATABpAGcAaAB0ACAAQgBsAHUAZQAtAFYAaQBvAGwAZQB0
AAAAADMAAADMAAAAAAAAEQBEAGEAcgBrACAAQgBsAHUAZQAtAFYAaQBvAGwA
ZQB0AAAAAJkAZgD/AAAAAAAAEgBMAGkAZwBoAHQAIABWAGkAbwBsAGUAdAAt
AEIAbAB1AGUAAAAAZgAzAMwAAAAAAAATAE0AZQBkAGkAdQBtACAAVgBpAG8A
bABlAHQALQBCAGwAdQBlAAAAADMAAACZAAAAAAAAEQBEAGEAcgBrACAAVgBp
AG8AbABlAHQALQBCAGwAdQBlAAAAAGYAAAD/AAAAAAAAEwBWAGkAbwBsAGUA
dAAtAFYAaQBvAGwAZQB0AC0AQgBsAHUAZQAAAACZADMA/wAAAAAAABIATABp
AGcAaAB0ACAASABhAHIAZAAgAFYAaQBvAGwAZQB0AAAAAGYAAADMAAAAAAAA
EQBEAGEAcgBrACAASABhAHIAZAAgAFYAaQBvAGwAZQB0AAAAAMwAmQD/AAAA
AAAAEQBQAGEAbABlACAARAB1AGwAbAAgAFYAaQBvAGwAZQB0AAAAAJkAZgDM
AAAAAAAAEgBMAGkAZwBoAHQAIABEAHUAbABsACAAVgBpAG8AbABlAHQAAAAA
ZgAzAJkAAAAAAAARAEQAYQByAGsAIABEAHUAbABsACAAVgBpAG8AbABlAHQA
AAAAMwAAAGYAAAAAAAAUAE8AYgBzAGMAdQByAGUAIABEAHUAbABsACAAVgBp
AG8AbABlAHQAAAAAmQAAAP8AAAAAAAAWAFYAaQBvAGwAZQB0AC0AVgBpAG8A
bABlAHQALQBNAGEAZwBlAG4AdABhAAAAAMwAZgD/AAAAAAAAFQBMAGkAZwBo
AHQAIABWAGkAbwBsAGUAdAAtAE0AYQBnAGUAbgB0AGEAAAAAmQAzAMwAAAAA
AAAWAE0AZQBkAGkAdQBtACAAVgBpAG8AbABlAHQALQBNAGEAZwBlAG4AdABh
AAAAAGYAAACZAAAAAAAAFABEAGEAcgBrACAAVgBpAG8AbABlAHQALQBNAGEA
ZwBlAG4AdABhAAAAAMwAMwD/AAAAAAAAFQBMAGkAZwBoAHQAIABNAGEAZwBl
AG4AdABhAC0AVgBpAG8AbABlAHQAAAAAmQAAAMwAAAAAAAAUAEQAYQByAGsA
IABNAGEAZwBlAG4AdABhAC0AVgBpAG8AbABlAHQAAAAAzAAAAP8AAAAAAAAX
AE0AYQBnAGUAbgB0AGEALQBNAGEAZwBlAG4AdABhAC0AVgBpAG8AbABlAHQA
AAAA/wAAAP8AAAAAAAAIAE0AYQBnAGUAbgB0AGEAAAAA/wAzAP8AAAAAAAAT
AEwAaQBnAGgAdAAgAEgAYQByAGQAIABNAGEAZwBlAG4AdABhAAAAAMwAAADM
AAAAAAAAEgBEAGEAcgBrACAASABhAHIAZAAgAE0AYQBnAGUAbgB0AGEAAAAA
/wBmAP8AAAAAAAAUAEwAaQBnAGgAdAAgAEYAYQBkAGUAZAAgAE0AYQBnAGUA
bgB0AGEAAAAAzAAzAMwAAAAAAAAVAE0AZQBkAGkAdQBtACAARgBhAGQAZQBk
ACAATQBhAGcAZQBuAHQAYQAAAACZAAAAmQAAAAAAABMARABhAHIAawAgAEYA
YQBkAGUAZAAgAE0AYQBnAGUAbgB0AGEAAAAA/wCZAP8AAAAAAAASAFAAYQBs
AGUAIABEAHUAbABsACAATQBhAGcAZQBuAHQAYQAAAADMAGYAzAAAAAAAABMA
TABpAGcAaAB0ACAARAB1AGwAbAAgAE0AYQBnAGUAbgB0AGEAAAAAmQAzAJkA
AAAAAAASAEQAYQByAGsAIABEAHUAbABsACAATQBhAGcAZQBuAHQAYQAAAABm
AAAAZgAAAAAAABUATwBiAHMAYwB1AHIAZQAgAEQAdQBsAGwAIABNAGEAZwBl
AG4AdABhAAAAAP8AzAD/AAAAAAAAEgBQAGEAbABlACAAVwBlAGEAawAgAE0A
YQBnAGUAbgB0AGEAAAAAzACZAMwAAAAAAAATAEwAaQBnAGgAdAAgAFcAZQBh
AGsAIABNAGEAZwBlAG4AdABhAAAAAJkAZgCZAAAAAAAAFABNAGUAZABpAHUA
bQAgAFcAZQBhAGsAIABNAGEAZwBlAG4AdABhAAAAAGYAMwBmAAAAAAAAEgBE
AGEAcgBrACAAVwBlAGEAawAgAE0AYQBnAGUAbgB0AGEAAAAAMwAAADMAAAAA
AAAVAE8AYgBzAGMAdQByAGUAIABXAGUAYQBrACAATQBhAGcAZQBuAHQAYQAA
AAD/AAAAzAAAAAAAABUATQBhAGcAZQBuAHQAYQAtAE0AYQBnAGUAbgB0AGEA
LQBQAGkAbgBrAAAAAP8AMwDMAAAAAAAAEwBMAGkAZwBoAHQAIABNAGEAZwBl
AG4AdABhAC0AUABpAG4AawAAAADMAAAAmQAAAAAAABIARABhAHIAawAgAE0A
YQBnAGUAbgB0AGEALQBQAGkAbgBrAAAAAP8AZgDMAAAAAAAAEwBMAGkAZwBo
AHQAIABQAGkAbgBrAC0ATQBhAGcAZQBuAHQAYQAAAADMADMAmQAAAAAAABQA
TQBlAGQAaQB1AG0AIABQAGkAbgBrAC0ATQBhAGcAZQBuAHQAYQAAAACZAAAA
ZgAAAAAAABIARABhAHIAawAgAFAAaQBuAGsALQBNAGEAZwBlAG4AdABhAAAA
AP8AAACZAAAAAAAAEgBQAGkAbgBrAC0AUABpAG4AawAtAE0AYQBnAGUAbgB0
AGEAAAAA/wAzAJkAAAAAAAAQAEwAaQBnAGgAdAAgAEgAYQByAGQAIABQAGkA
bgBrAAAAAMwAAABmAAAAAAAADwBEAGEAcgBrACAASABhAHIAZAAgAFAAaQBu
AGsAAAAA/wCZAMwAAAAAAAAPAFAAYQBsAGUAIABEAHUAbABsACAAUABpAG4A
awAAAADMAGYAmQAAAAAAABAATABpAGcAaAB0ACAARAB1AGwAbAAgAFAAaQBu
AGsAAAAAmQAzAGYAAAAAAAAPAEQAYQByAGsAIABEAHUAbABsACAAUABpAG4A
awAAAABmAAAAMwAAAAAAABIATwBiAHMAYwB1AHIAZQAgAEQAdQBsAGwAIABQ
AGkAbgBrAAAAAP8AAABmAAAAAAAADgBQAGkAbgBrAC0AUABpAG4AawAtAFIA
ZQBkAAAAAP8AZgCZAAAAAAAADwBMAGkAZwBoAHQAIABQAGkAbgBrAC0AUgBl
AGQAAAAAzAAzAGYAAAAAAAAQAE0AZQBkAGkAdQBtACAAUABpAG4AawAtAFIA
ZQBkAAAAAJkAAAAzAAAAAAAADgBEAGEAcgBrACAAUABpAG4AawAtAFIAZQBk
AAAAAP8AMwBmAAAAAAAADwBMAGkAZwBoAHQAIABSAGUAZAAtAFAAaQBuAGsA
AAAAzAAAADMAAAAAAAAOAEQAYQByAGsAIABSAGUAZAAtAFAAaQBuAGsAAAAA
/wAAADMAAAAAAAANAFIAZQBkAC0AUgBlAGQALQBQAGkAbgBrAAA=
      EOS

      EXERCISE = <<-EOS
AAIABwAAHgA8AFoAAAAAAAAEAFIARwBCAAAAAQKPGZn//wAAAAAABABIAFMA
QgAAAAIMzH//GZn//wAAAAUAQwBNAFkASwAAAAcbWOiQG1gAAAAAAAQATABB
AEIAAAAIFXwAAAAAAAAAAAAFAEcAcgBhAHkAAAAJCcQNrBGUBdwAAAAGAFcA
QwBNAFkASwAAAA0JxA2sEZQF3AAAAAsAVQBOAEsATgBPAFcATgAgADEAMwAA
      EOS

# http://www.visibone.com/swatches/VisiBone.aco
# http://www.visibone.com/swatches/VisiBone2.aco
# http://www.visibone.com/swatches/VisiBone2_km.psppalette
# http://www.visibone.com/swatches/VisiBone2_km.pal
# http://www.visibone.com/swatches/VisiBone2_vaccc.ai
# http://www.visibone.com/swatches/VisiBone.gimp
# http://www.visibone.com/swatches/VisiBone.act

      def setup
        @filename = "test#{Process.pid}.aco"
      end

      def teardown
        require 'fileutils'
        FileUtils.rm_f @filename if File.exist? @filename
      end

      def test_version1
        v1 = VISIBONE_V1.unpack("m*")[0]
        assert_nothing_raised { @aco = AdobeColor.new(v1) }
        assert_equal(216, @aco.size)
        assert_equal(1, @aco.version)
        assert_equal({:rgb => 216}, @aco.statistics)
        assert_equal(Color::RGB::White, @aco[0])
        assert_equal("#ff0033", @aco[-1].html)
        assert_equal(v1, @aco.to_aco)
      end

      def test_version2
        v2 = VISIBONE_V2.unpack("m*")[0]
        @aco = AdobeColor.new(v2)
        assert_equal(216, @aco.size)
        assert_equal(2, @aco.version)
        assert_equal({:rgb => 216}, @aco.statistics)
        assert_equal(Color::RGB::White, @aco[0])
        assert_equal(Color::RGB::White,
                     @aco["\000W\000h\000i\000t\000e"][0])
        assert_equal("#ff0033", @aco[-1].html)
        assert_equal("#ff0033",
                     @aco["\000R\000e\000d\000-\000R\000e\000d\000-\000P\000i\000n\000k"][0].html)
        assert_equal(v2, @aco.to_aco)
      end

      def test_bogus
        o = VISIBONE_V2.unpack("m*")[0]
        v = o.dup
        v[0, 2] = [ 322 ].pack("n") # break the version
        assert_raises(RuntimeError) { AdobeColor.new(v) }
        v = o.dup
        v[2, 2] = [ 217 ].pack("n") # break the colour count
        assert_raises(IndexError) { @aco = AdobeColor.new(v) }
        v = o.dup
        v[14, 2] = [ 99 ].pack("n") # break the NULL before the name
        assert_raises(IndexError) { @aco = AdobeColor.new(v) }
        v = o.dup
        v[16, 2] = [ 18 ].pack("n") # break the length of the name
        assert_raises(IndexError) { @aco = AdobeColor.new(v) }
        v = o.dup
        v[28, 2] = [ 99 ].pack("n") # break the trailing null of the name
      end

      def test_exercise
        assert_nothing_raised do
          File.open(@filename, "wb") do |f|
            f.write EXERCISE.unpack("m*")[0]
          end
        end
        assert_nothing_raised { @aco = AdobeColor.from_file(@filename) }
        assert_equal(5, @aco.size)
        assert_equal(7, @aco.instance_variable_get(:@order).size)
      end

      def test_each
        v1 = VISIBONE_V1.unpack("m*")[0]
        @aco = AdobeColor.new(v1)
        @aco.each { |c| assert_kind_of(Color::RGB, c) }
      end

      def test_each_name
        v2 = VISIBONE_V2.unpack("m*")[0]
        assert_nothing_raised { @aco = AdobeColor.new(v2) }
        assert_equal(216, @aco.size)
        assert_equal(2, @aco.version)
        @aco.each_name do |n, s|
          assert_equal(0, n[0]) if RUBY_VERSION < "1.9"
          assert_equal(1, s.size)
          assert_kind_of(Color::RGB, s[0])
        end
      end

      def test_values_at
        v2 = VISIBONE_V2.unpack("m*")[0]
        assert_nothing_raised { @aco = AdobeColor.new(v2) }
        assert_equal(216, @aco.size)
        assert_equal(2, @aco.version)
        assert_equal([Color::RGB::White, Color::RGB.from_html("#ff0033")],
                     @aco.values_at(0, -1))
      end
    end
  end
end
