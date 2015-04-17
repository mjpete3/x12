#--
#     This file is part of the X12Parser library that provides tools to
#     manipulate X12 messages using Ruby native syntax.
#
#     http://x12parser.rubyforge.org
#
#     Copyright (C) 2012 P&D Technical Solutions, LLC.
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

class Test271Parse < Test::Unit::TestCase

  MESSAGE = "ISA*00* *00* *ZZ*6175910AAC21T *ZZ*54503516A *061130*1445*U*00401*309242122*0*T*:~
GS*HB*617591011C21T*545035165*20030924*21000083*309001*X*004010X092A1~
ST*271*COMP1420~
BHT*0022*11**20030924*21000083~
HL*1**20*1~
NM1*PR*2*Texas Medicaid/Healthcare Services*****PI*617591011C21T~
HL*2*1*21*1~
NM1*1P*1******XX*1234567890~
HL*3*2*22*0~
TRN*1*COMPASS 21*3617591011~
TRN*2*109834652831*9877281234*RADIOLOGY~
TRN*2*98175-012547*9877281234*RADIOLOGY~
NM1*IL*1*LASTNAME*FIRSTNAME*M**SUFFIX*MI*444115555~
REF*SY*123456789~
REF*F6*123456789012~
REF*Q4*999888777~
REF*EJ*111222333444555~
N3*123 STREET~
N4*DALLAS*TX*75024**CY*85~
DMG*D8*19850201*M~
INS*Y*18*001*25~
EB*1*IND*30**PLANABBVDE~
EB*R*IND*30*OT*CC~
REF*6P*G123456*EMPLOYERNAME~
DTP*193*D8*20000501~
DTP*194*D8*20000601~
LS*2120~
NM1*PR*2*INCOMPANYNAME~
N3*123 STREET~
N4*DALLAS*TX*75024~
PER*IC**WP*2145551212~
LE*2120~
EB*R*IND*30*OT*CC~
REF*6P*G123456*EMPLOYERNAME~
DTP*193*D8*20000501~
DTP*194*D8*20000601~
LS*2120~
NM1*IL*1*LASTNAME*FIRST*M**SUFFIX*MI*123456789~
LE*2120~
EB*R*IND*30*OT*EE~
REF*6P*G345678 *EMPLOYERNAME~
DTP*193*D8*20000701~
DTP*194*D8*20000801~
LS*2120~
NM1*IL*1*LASTNAME*THIRD*M**SUFFIX*MI*345678901~
LE*2120~
SE*45*COMP1420~
GE*1*309001~
IEA*1*309242122~"


  def setup
    @message = MESSAGE
    # make the result usable in the tests
    @message.gsub!(/\n/,'')

    @parser = X12::Parser.new('271.xml')
    @r = @parser.parse('271', @message)
  end


  def teardown
    #nothing
  end


  def test_header
    assert_equal("00", @r.ISA.AuthorizationInformationQualifier)
    assert_equal("          ", @r.ISA.AuthorizationInformation)
    assert_equal("00", @r.ISA.SecurityInformationQualifier)
    assert_equal("          ", @r.ISA.SecurityInformation)
    assert_equal("ZZ", @r.ISA.InterchangeIdQualifier1)
    assert_equal("6175910AAC21T  ", @r.ISA.InterchangeSenderId)
    assert_equal("ZZ", @r.ISA.InterchangeIdQualifier2)
    assert_equal("54503516A      ", @r.ISA.InterchangeReceiverId)
    assert_equal("061130", @r.ISA.InterchangeDate)
    assert_equal("1445", @r.ISA.InterchangeTime)
    assert_equal("U", @r.ISA.InterchangeControlStandardsIdentifier)
    assert_equal("00401", @r.ISA.InterchangeControlVersionNumber)
    assert_equal("309242122", @r.ISA.InterchangeControlNumber)
    assert_equal("0", @r.ISA.AcknowledgmentRequested)
    assert_equal("T", @r.ISA.UsageIndicator)
    assert_equal(":", @r.ISA.ComponentElementSeparator)

    assert_equal("HB", @r.GS.FunctionalIdentifierCode)
    assert_equal("617591011C21T", @r.GS.ApplicationSendersCode)
    assert_equal("545035165", @r.GS.ApplicationReceiversCode)
    assert_equal("20030924", @r.GS.Date)
    assert_equal("21000083", @r.GS.Time)
    assert_equal("309001", @r.GS.GroupControlNumber)
    assert_equal("X", @r.GS.ResponsibleAgencyCode)
    assert_equal("004010X092A1", @r.GS.VersionReleaseIndustryIdentifierCode)

    assert_equal("271", @r.ST.TransactionSetIdentifierCode)
    assert_equal("COMP1420", @r.ST.TransactionSetControlNumber)
  end


  def test_trailer
    assert_equal("45", @r.SE.NumberOfIncludedSegments)
    assert_equal("COMP1420", @r.SE.TransactionSetControlNumber)
    assert_equal("1", @r.GE.NumberOfTransactionSetsIncluded)
    assert_equal("309001", @r.GE.GroupControlNumber)
    assert_equal("1", @r.IEA.NumberOfIncludedFunctionalGroups)
    assert_equal("309242122", @r.IEA.InterchangeControlNumber)
  end

  def test_each_loop
    # each loop for Loops
    # each loop for Segments
  end

  def test_various_fields

  end


  def test_timing
    start = Time::now
    X12::TEST_REPEAT.times do
      @r = @parser.parse('271', @message)
    end
    finish = Time::now
    puts sprintf("Parses per second, 271: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing


end

