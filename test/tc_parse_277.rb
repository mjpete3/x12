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

class Test277Parse < Test::Unit::TestCase
  
  MESSAGE = "ISA*00*0000000000*00*0000000000*01*091712414000000*ZZ*Trading Partner*020808*0931*U*00401*000000002*0*T*:~
GS*HN*952931460*Trading Partner*20020808*0931*2*X*004010X093~
ST*277*0002~
BHT*0010*08*3920394930203*20020808**DG~
HL*1**20*1~
NM1*PR*2*PACIFICARE/SECURE HORIZONS*****PI*952931460~
PER*IC**TE*8002037729~
HL*2*1*21*1~
NM1*41*2*Clearing House USA*****46*X67E~
HL*3*2*19*1~
NM1*1P*2*CURE ALL*****XX*1122334455~
HL*4*3*22*0~
DMG*D8*19650625*F~
NM1*QC*1*POPPINS*MARY****MI*111222301~
TRN*2*000000001~
STC*P1:20*20020808**550.00*550.00~
REF*1K*1112223010001~
REF*BLT*111~
REF*EA*3920394930203~
DTP*232*RD8*20020228-20020228~
SVC*HC:99291*550.00*550.00~
STC*P1:20*20020808**550.00*550.00~
REF*FJ*1~
DTP*472*RD8*20020228-20020228~
SE*23*0002~
GE*1*2~
IEA*1*000000002~"

  def setup
    # result message that we are building and will test against
    @message = MESSAGE
    # make the result usable in the tests
    @message.gsub!(/\n/,'')

    @parser = X12::Parser.new('277.xml')
    @r = @parser.parse('277', @message)
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
    assert_equal("01", @r.ISA.InterchangeIdQualifier1)
    assert_equal("091712414000000", @r.ISA.InterchangeSenderId)
    assert_equal("ZZ", @r.ISA.InterchangeIdQualifier2)
    assert_equal("Trading Partner", @r.ISA.InterchangeReceiverId)
    assert_equal("020808", @r.ISA.InterchangeDate)
    assert_equal("0931", @r.ISA.InterchangeTime)
    assert_equal("U", @r.ISA.InterchangeControlStandardsIdentifier)
    assert_equal("00401", @r.ISA.InterchangeControlVersionNumber)
    assert_equal("000000002", @r.ISA.InterchangeControlNumber)
    assert_equal("0", @r.ISA.AcknowledgmentRequested)
    assert_equal("T", @r.ISA.UsageIndicator)
    assert_equal(":", @r.ISA.ComponentElementSeparator)

    assert_equal("HN", @r.GS.FunctionalIdentifierCode)
    assert_equal("952931460", @r.GS.ApplicationSendersCode)
    assert_equal("Trading Partner", @r.GS.ApplicationReceiversCode)
    assert_equal("20020808", @r.GS.Date)
    assert_equal("0931", @r.GS.Time)
    assert_equal("2", @r.GS.GroupControlNumber)
    assert_equal("X", @r.GS.ResponsibleAgencyCode)
    assert_equal("004010X093", @r.GS.VersionReleaseIndustryIdentifierCode)

    assert_equal("277", @r.ST.TransactionSetIdentifierCode)
    assert_equal("0002", @r.ST.TransactionSetControlNumber)
  end

  def test_trailer
    assert_equal("23", @r.SE.NumberOfIncludedSegments)
    assert_equal("0002", @r.SE.TransactionSetControlNumber)
    assert_equal("1", @r.GE.NumberOfTransactionSetsIncluded)
    assert_equal("2", @r.GE.GroupControlNumber)
    assert_equal("1", @r.IEA.NumberOfIncludedFunctionalGroups)
    assert_equal("000000002", @r.IEA.InterchangeControlNumber)
  end


  def test_timing
    start = Time::now
    X12::TEST_REPEAT.times do
      @r = @parser.parse('277', @message)
    end
    finish = Time::now
    puts sprintf("Parses per second, 277: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing

  
end
