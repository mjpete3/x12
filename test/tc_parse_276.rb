#--
#     This file is part of the X12Parser library that provides tools to
#     manipulate X12 messages using Ruby native syntax.
#
#     http://x12parser.rubyforge.org
#
#     Copyright (C) 2012, 2013 P&D Technical Solutions, LLC.
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

class Test276Parse < Test::Unit::TestCase
  
  # patient is the subscriber
  MESSAGE1 = "ISA*00*0000000000*00*0000000000*ZZ*610017         *ZZ*T0001799       *030430*1700*U*00401*000000157*0*P*:~
GS*HB*610017*T0001799*20030430*1700190*1570001*X*004010X092A1~ST*276*0046~
BHT*0010*13**20030109~
HL*1**20*1~
NM1*PR*2*PAYER NAME*****21*9012345918341~
PER*IC*PROVIDER CONTACT INFO*TE*6145551212~
HL*2*1*21*1~
NM1*41*2******46*111222333~
HL*3*2*19*1~
NM1*1P*2*PROVIDER NAME*****FI*FEDERAL TAX ID~
NM1*1P*2*PROVIDER NAME*****XX*NPI NUMBER~
NM1*1P*2*PROVIDER NAME*****SV*PROVIDER NUMBER~
HL*4*3*22*0~
DMG*D8*19191029*M~
NM1*QC*1*DOE*JOHN****MI*R11056841~
TRN*1*500~
REF*1K*940922~
REF*BLT*131~
AMT*T3*28.00~
DTP*232*RD8*20020501-20020501~
SE*18*0046~
GE*1*1570001~
IEA*1*000000157~"

  # patient and subscriber are different
  MESSAGE2 = "ISA*00*0000000000*00*0000000000*ZZ*610017         *ZZ*T0001799       *030430*1700*U*00401*000000157*0*P*:~
GS*HB*610017*T0001799*20030430*1700190*1570001*X*004010X092A1~
ST*276*0046~
BHT*0010*13**20030109~
HL*1**20*1~
NM1*PR*2* PAYER NAME ****21*9012345918341~
PER*IC*PROVIDER CONTACT INFO*TE*6145551212~
HL*2*1*21*1~
NM1*41*2******46*111222333~
HL*3*2*19*1~
NM1*1P*2*PROVIDER NAME*****FI*FEDERAL TAX ID~
NM1*1P*2*PROVIDER NAME*****XX*NPI NUMBER~
NM1*1P*2*PROVIDER NAME*****SV*PROVIDER NUMBER~
HL*4*3*22*1~
NM1*IL*1*DOE*JOHN****MI*MEMBER ID~
TRN*1*500~
HL*5*4*23~
DMG*D8*DATE OF BIRTH*F~
NM1*QC*1*DOE*JANE~
TRN*1*500~
AMT*T3*68.69~
DTP*232*RD8*20021016-20021016~
SE*18*0046~
GE*1*1570001~
IEA*1*000000157~"

  def setup
    # result message that we are building and will test against
    @message1 = MESSAGE1
    # make the result usable in the tests
    @message1.gsub!(/\n/,'')

    @parser = X12::Parser.new('276.xml')
    @r = @parser.parse('276', @message1)
  end
  
  
  def teardown
    #nothing
  end


  def test_basic
    
  end

  def test_header
    assert_equal("00", @r.ISA.AuthorizationInformationQualifier)
    assert_equal("0000000000", @r.ISA.AuthorizationInformation)
    assert_equal("00", @r.ISA.SecurityInformationQualifier)
    assert_equal("0000000000", @r.ISA.SecurityInformation)
    assert_equal("ZZ", @r.ISA.InterchangeIdQualifier1)
    assert_equal("610017         ", @r.ISA.InterchangeSenderId)
    assert_equal("ZZ", @r.ISA.InterchangeIdQualifier2)
    assert_equal("T0001799       ", @r.ISA.InterchangeReceiverId)
    assert_equal("030430", @r.ISA.InterchangeDate)
    assert_equal("1700", @r.ISA.InterchangeTime)
    assert_equal("U", @r.ISA.InterchangeControlStandardsIdentifier)
    assert_equal("00401", @r.ISA.InterchangeControlVersionNumber)
    assert_equal("000000157", @r.ISA.InterchangeControlNumber)
    assert_equal("0", @r.ISA.AcknowledgmentRequested)
    assert_equal("P", @r.ISA.UsageIndicator)
    assert_equal(":", @r.ISA.ComponentElementSeparator)

    assert_equal("HB", @r.GS.FunctionalIdentifierCode)
    assert_equal("610017", @r.GS.ApplicationSendersCode)
    assert_equal("T0001799", @r.GS.ApplicationReceiversCode)
    assert_equal("20030430", @r.GS.Date)
    assert_equal("1700190", @r.GS.Time)
    assert_equal("1570001", @r.GS.GroupControlNumber)
    assert_equal("X", @r.GS.ResponsibleAgencyCode)
    assert_equal("004010X092A1", @r.GS.VersionReleaseIndustryIdentifierCode)

    assert_equal("276", @r.ST.TransactionSetIdentifierCode)
    assert_equal("0046", @r.ST.TransactionSetControlNumber)
  end

  def test_trailer
    assert_equal("18", @r.SE.NumberOfIncludedSegments)
    assert_equal("0046", @r.SE.TransactionSetControlNumber)
    assert_equal("1", @r.GE.NumberOfTransactionSetsIncluded)
    assert_equal("1570001", @r.GE.GroupControlNumber)
    assert_equal("1", @r.IEA.NumberOfIncludedFunctionalGroups)
    assert_equal("000000157", @r.IEA.InterchangeControlNumber)
  end

  def test_timing
    start = Time::now
    X12::TEST_REPEAT.times do
      @r = @parser.parse('276', @message1)
    end
    finish = Time::now
    puts sprintf("Parses per second, 276: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing

end
