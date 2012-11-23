#--
#     This file is part of the X12Parser library that provides tools to
#     manipulate X12 messages using Ruby native syntax.
#
#     http://x12parser.rubyforge.org 
#     
#     Copyright (C) 2008 APP Design, Inc.
#
#     This library is free software; you can redistribute it and/or
#     modify it under the terms of the GNU Lesser General Public
#     License as published by the Free Software Foundation; either
#     version 2.1 of the License, or (at your option) any later version.
#
#     This library is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#     Lesser General Public License for more details.
#
#     You should have received a copy of the GNU Lesser General Public
#     License along with this library; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#++
#
require 'x12'
require 'test/unit'

class Test270ParseInterchange < Test::Unit::TestCase

  @@p = nil
  @@parser = X12::Parser.new('misc/270interchange.xml')

  def setup
    unless @@p
      @@m=<<-EOT
ISA*03*user      *01*password  *ZZ*0000000Eliginet*ZZ*CHICAGO BLUES*070724*1726*U*00401*230623206*0*T*:~
GS*HS*0000000Eliginet*CHICAGO BLUES*20070724*1726*000*X*004010X092A1~
ST*270*0000~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*RED CROSS*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*LastName*FirstName~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*0000~
ST*270*0001~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*RED CROSS*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*LastName*FirstName~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*0001~
ST*270*0002~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*RED CROSS*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*LastName*FirstName~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*0002~
GE*3*000~
GS*HS*0000000Eliginet*CHICAGO BLUES*20070724*1726*001*X*004010X092A1~
ST*270*1000~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*RED CROSS*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*LastName*FirstName~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*1000~
ST*270*1001~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*RED CROSS*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*LastName*FirstName~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*1001~
GE*2*001~
GS*HS*0000000Eliginet*CHICAGO BLUES*20070724*1726*002*X*004010X092A1~
ST*270*2000~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*RED CROSS*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*LastName*FirstName~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*2000~
GE*1*002~
IEA*3*230623206~
EOT
      @@m.gsub!(/\n/,'')

      @@p = @@parser.parse('270interchange', @@m)
    end
    @r = @@p
#    @@p.show

  end # setup

  def teardown
    # Nothing
  end # teardown

   def test_ISA_IEA
     assert_equal('ISA*03*user      *01*password  *ZZ*0000000Eliginet*ZZ*CHICAGO BLUES*070724*1726*U*00401*230623206*0*T*:~', @r.ISA.to_s)
     assert_equal('0000000Eliginet', @r.ISA.InterchangeSenderId)
     assert_equal('3', @r.IEA.NumberOfIncludedFunctionalGroups)

   end # test_ST

  def test_FG
    fg = @r.FG
    assert_equal(3, fg.to_a.size)
    assert_equal(3, fg.size)
    assert_equal(3, fg[0].find('270').to_a.size)
    assert_equal(2, fg[1].find('270').size)
    assert_equal(1, fg[2]._270.size)
    assert_equal('3', fg[0].GE.NumberOfTransactionSetsIncluded)
    assert_equal('001', fg[1].GE.GroupControlNumber)
    assert_equal('002', fg[2].GS.GroupControlNumber)
  end

  def test_ST
    assert_equal('ST*270*1001~', @r.FG[1]._270[1].ST.to_s)
    assert_equal('270', @r.FG[1]._270[1].ST.TransactionSetIdentifierCode)
  end # test_ST

  def test_L2000A_NM1
    assert_equal('RED CROSS', @r.FG[1]._270[1].L2000A.L2100A.NM1.NameLastOrOrganizationName)
  end

  def test_L2000C_NM1
    @r.FG[1].with { |fg|
      fg._270[1].with {|_270|
        _270.L2000C {|l2000C|
          l2000C.L2100C {|l2100C|
            l2100C.NM1 {|nm1|
              assert_equal('FirstName', nm1.NameFirst)
            }
          }
        }
      }
    }
  end

  def test_L2000A_HL
    assert_equal('', @r.FG[1]._270[1].L2000A.HL.HierarchicalParentIdNumber)
  end

  def test_timing
    start = Time::now
    X12::TEST_REPEAT.times do
      @r = @@parser.parse('270interchange', @@m)
    end
    finish = Time::now
    puts sprintf("Parses per second, 270interchange: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing

end # TestParse
