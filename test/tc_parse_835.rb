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

class Test835Parse < Test::Unit::TestCase

  MESSAGE = "ISA*00*          *00*          *ZZ*5010TEST       *ZZ*835RECVR       *110930*1105*^*00501*000004592*0*T*:~
GS*HP*5010TEST*835RECVR*20110930*100718*45920001*X*005010X221A1~
ST*835*0001~BPR*I*57.44*C*CHK************20110930~
TRN*1*123456789*1123456789~
REF*EV*5010835EXAMPLE~
DTM*405*20110930~
N1*PR*PAYER NAME~
N3*PAYER ADDRESS~
N4*CINCINNATI*OH*45206~
PER*CX**TE*8003030303~
PER*BL*TECHNICAL CONTACT*TE*8004040404*EM*PAYER@PAYER.COM~
PER*IC**UR*WWW.PAYER.COM~
N1*PE*PROVIDER NAME*XX*1122334455~
N3*PROVIDER ADDRESS~
N4*CITY*OH*89999~
REF*TJ*123456789~
LX*1~
CLP*EDI DENIAL*1*1088*0*1088*HM*CLAIMNUMBER1*21~
NM1*QC*1*LAST*FIRST****MI*1A2A1A2A1A2A~
NM1*IL*1*LAST1*FIRST1*G***MI*BBB1A2A1A2A1A2A~
NM1*82*1*PROVIDER*MR*A***XX*1234567898~
REF*EA*11223344~
REF*1L*123456~
DTM*232*20090113~
DTM*233*20090113~
DTM*050*20110908~
SVC*HC:00220:P2*1088*0**8**76~
DTM*150*20090113~
DTM*151*20090113~
CAS*PR*29*1088~
CLP*EDI PAID*1*100*57.44*30*12*CLAIMNUMBER2*11~
NM1*QC*1*LAST2*FIRST2*A***MI*R123456789~
NM1*IL*1*LAST3*FIRST3*B***MI*R1234567~
NM1*82*1*PROVIDER1*MRS1*B***XX*1234567899~
REF*EA*11223344~
REF*1L*123456~
DTM*232*20110729~
DTM*233*20110729~
DTM*050*20110927~
SVC*HC:97110*100*57.44**2~
DTM*150*20110729~
DTM*151*20110729~
CAS*PR*3*30~
CAS*CO*45*12.56~
AMT*B6*87.44~
SE*45*0001~
GE*1*45920001~
IEA*1*000004592~"

  MESSAGE1 = "ISA*00*          *00*          *ZZ*5010TEST       *ZZ*835RECVR       *110930*1105*^*00501*000004592*0*T*:~
GS*HP*330897513*835RECVR*20140514*1605*188915716*X*005010X221A1~
ST*835*0001~
BPR*I*280.56*C*ACH*CCP*01*011900445*DA*0000009046*1066033492**01*031201360*DA*7869322623*20140519~
TRN*1*814133500000415*1066033492~
REF*EV*330897513~
DTM*405*20140514~
N1*PR*AETNA~
N3*151 FARMINGTON AVENUE~
N4*HARTFORD*CT*06156~
PER*BL*PROVIDER SERVICE~
N1*PE*SERVICES OF INTEREST*XX*1457686560~
N3*77 WILLIAM ST~
N4*SOUTH RIVER*NJ*088821072~
REF*PQ*149850620~
REF*TJ*263895688~
CLP*687400A140313*22*-150*-45**13*E7TWCV68K0000*11*1~
NM1*QC*1*BETTY*ELIZABETH****MI*W193272207~
NM1*82*1*HURTEM*DEBBIE****XX*1457686560~
REF*1L*0701087-022-00002-UA~
REF*CE*AETNA~
DTM*050*20140314~
DTM*232*20140308~
DTM*233*20140308~
PER*CX**TE*8886323862~
SVC*HC:90834*-150*-45**1~
DTM*472*20140308~
CAS*CO*45*-90~
CAS*PR*3*-15~
CLP*652000A140307*22*-150*-45**13*ECABDCJH40000*11*1~
NM1*QC*1*VANDERBROOK*JOHN~
NM1*IL*1*KRAFT*FRANK****MI*W142202122~
NM1*74*1**FRANCES*G~
NM1*82*1*HOMLEY*MEGAN****XX*1457686560~
REF*1L*0701087-022-00003-UA~
REF*CE*AETNA~
DTM*050*20140310~
DTM*232*20140306~
DTM*233*20140306~
PER*CX**TE*8886323862~
SVC*HC:90834*-150*-45**1~
DTM*472*20140306~
CAS*CO*45*-90~
CAS*PR*3*-15~
AMT*B6*60~
SE*44*0001~
GE*7*188915716~
IEA*1*188915716~"

  def setup
    # readable format
    @message = MESSAGE
    # make the result usable in the tests
    @message.gsub!(/\n/,'')

    @parser = X12::Parser.new('835.xml')
    @r = @parser.parse('835', @message)

    # second message for testing negatives
    @message1 = MESSAGE1
    @message1.gsub!(/\n/,'')
    @r1 = @parser.parse('835', @message1)
  end

  def teardown
    #nothing
  end

  def test_ISA_IEA
     assert_equal('ISA*00*          *00*          *ZZ*5010TEST       *ZZ*835RECVR       *110930*1105*^*00501*000004592*0*T*:~', @r.ISA.to_s)
     assert_equal('5010TEST       ', @r.ISA.InterchangeSenderId)
     assert_equal('1', @r.IEA.NumberOfIncludedFunctionalGroups)
  end # test_ST

  def test_GS_GE
    assert_equal("HP", @r.GS.FunctionalIdentifierCode)
    assert_equal("45920001", @r.GS.GroupControlNumber)
    assert_equal(@r.GS.GroupControlNumber, @r.GE.GroupControlNumber)
  end

  def test_segment_each0
    assert_equal(3, @r.L1000A.PER.size)

    # loop through the PER segment and find the CX record
    @r.L1000A.PER.each do |per|
      if per.ContactFunctionCode == "CX"
        assert_equal("TE", per.CommunicationNumberQualifier1)
      end
    end

    #loop through the PER segment anf find the BL record
    @r.L1000A.PER.each do |per|
      if per.ContactFunctionCode == "BL"
        assert_equal("TE", per.CommunicationNumberQualifier1)
        assert_equal("TECHNICAL CONTACT", per.Name)
        assert_equal("EM", per.CommunicationNumberQualifier2)
        assert_equal("PAYER@PAYER.COM", per.CommunicationNumber2)

      end
    end

    #loop through and find the IC record
    @r.L1000A.PER.each do |per|
      if per.ContactFunctionCode == "IC"
        assert_equal("UR", per.CommunicationNumberQualifier1)
        assert_equal("WWW.PAYER.COM", per.CommunicationNumber1)
      end
    end

  end

  def test_L2000_loop
    assert_equal("1", @r.L2000.LX.AssignedNumber)
    assert_equal("CLP*EDI DENIAL*1*1088*0*1088*HM*CLAIMNUMBER1*21~", @r.L2000.L2100[0].CLP.to_s)
    assert_equal("CLP*EDI PAID*1*100*57.44*30*12*CLAIMNUMBER2*11~", @r.L2000[0].L2100[1].CLP.to_s)
  end


  def test_negative
    # puts @r1.L2000[0].L2100[1].CLP.inspect
    assert_equal("-150", @r1.L2000[0].L2100[1].CLP.MonetaryAmount1)
    m1 = @r1.L2000[0].L2100[1].CLP.MonetaryAmount1
    assert_equal(-150, m1.to_i)

    assert_equal("-45", @r1.L2000[0].L2100[1].CLP.MonetaryAmount2)
    assert_equal(-45, @r1.L2000[0].L2100[1].CLP.MonetaryAmount2.to_i)
  end

  def test_timing
    start = Time::now
    X12::TEST_REPEAT.times do
      @r = @parser.parse('835', @message)
    end
    finish = Time::now
    puts sprintf("Parses per second, 835: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing
end

