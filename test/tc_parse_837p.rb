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

class Test837pParse < Test::Unit::TestCase

  def setup
    @parser = X12::Parser.new('837p.xml')
    @msg = []

    # sample 5010 837p test message
    @temporary = "ISA*00* *00* *ZZ*SENDERID       *33*NAIC *090809*1130*U*00501*000000230*1*T*:~GS*HC*SENDERID*NAIC*20090809*1615*230*X* 005010X222A1~ST*837*999999999*005010X222A1~BHT*0019*00*CLMSIPTP1*20090809*1834*CH~NM1*41*2*NAVINET*****46*PFAMPCLM~PER*IC*PROVIDER NAME*TE*PROVIDER CONTACT INFORMATION~NM1*40*2*RECEIVER NAME*****46*RECEIVER PRIMARY ID NUMBER~HL*1**20*1~NM1*85*2*PROVIDER NAME*****XX*NPI NUMBER~N3*PROVIER ADDRESS~N4*PROVIDER CITY*STATE*ZIP~REF*EI*FEDERAL TAX ID~HL*2*1*22*0~SBR*P*18**000163*****BL~NM1*IL*1*SUBSCRIBER NAME*****MI*SUBSCRIBER ID~N3*SUBSCRIBER ADDRESS~N4*SUBSCRIBER CITY*STATE*ZIP CODE~DMG*D8*SUBSCRIBER DATE OF BIRTH*SUBSCRIBER SEX~NM1*PR*2*PAYER NAME*****PI*PAYER ID NUMBER~N3*PAYER ADDRESS~N4*PAYER CITY*STATE*ZIP*COUNTRY~REF*G2*LEGACY NUMBER~CLM*PATIENT ACCOUNT NUMBER*195***11::1*Y*A*Y*Y*C******P~DTP*454*D8*20090701~NM1*82*2*RENDERING PROVIDER NAME*****XX*NPI NUMBER~PRV*PE*ZZ*207RC0000X~REF*G2*LEGACY NUMBER~LX*1~SV1*HC:92135*100*UN*1*****Y~DTP*472*D8*20090729~LX*2~SV1*HC:59840:LT*50*UN*1*****Y~DTP*472*D8*20090729~LX*3~SV1*HC:92012*45*UN*1*****Y~DTP*472*D8*20090729~SE*38*999999999~GE*1*230~IEA*1*000000230~"
    @msg << @temporary
    # 2 payors in test message
    @temporary = "ISA*00**00**ZZ*000009340000000*ZZ*000000010000000*100423*1740*^*00501*000000181*0*P*:~GS*HC*00000934*00000001*20100423*1740*181*X*005010X222A1~ST*837*0001*005010X222A1~BHT*0019*00*181*20100423*1740*CH~NM1*41*2*EDI BILLING*****46*00000934~PER*IC*BILLER NAME*TE*2135559999~NM1*40*2*LAC DEPARTMENT OF MENTAL HEALTH*****46*00000001~HL*1**20*1~NM1*85*2*PROVIDER NAME*****XX*1477632479~N3*146 WESTWOOD BLVD~N4*LOS ANGELES*CA*900059876~REF*EI*959999346~HL*2*1*22*0~SBR*S*18**1001*****11~NM1*IL*1*DOE*JOHN****MI*9998211~N3*15 BEFORD~N4*LOS ANGELES*CA*900359876~DMG*D8*19900923*F~NM1*PR*2*LAC DEPARTMENT OF MENTAL HEALTH*****PI*953893470~REF*FY*123100~CLM*0000181*150***12:B:1*Y*A*Y*Y*P~REF*G1*89194428225~HI*BK:30002~NM1*82*1*RENDERING*JOHN****XX*1518169325~PRV*PE*PXC*2084P0800X~SBR*P*18*******MC~OI***Y*P**Y~NM1*IL*1*DOE*JOHN****MI*99929939C~N3*15 BEFORD~N4*LOS ANGELES*CA*900359876~NM1*PR*2*MEDI-CAL*****PI*01~LX*1~SV1*HC:90847*150*UN*60***1~DTP*472*D8*20100403~SE*33*0001~GE*1*181~IEA*1*000000181~"
    @msg << @temporary

    @r = @parser.parse('837p', @msg[0])
  end

  def teardown
    #nothing
  end


  def test_ISA_IEA
     assert_equal('ISA*00* *00* *ZZ*SENDERID       *33*NAIC *090809*1130*U*00501*000000230*1*T*:~', @r.ISA.to_s)
     assert_equal('SENDERID       ', @r.ISA.InterchangeSenderId)
     assert_equal('1', @r.IEA.NumberOfIncludedFunctionalGroups)
  end # test_ST


  def test_loops
    assert_equal("NAVINET", @r.L837.L1000A.NM1.NameLastOrOrganizationName.to_s)
    assert_equal("PROVIDER NAME", @r.L837.L2010AA.NM1.NameLastOrOrganizationName.to_s)
    assert_equal("SUBSCRIBER NAME", @r.L837.L2010BA.NM1.NameLastOrOrganizationName.to_s)
    assert_equal("SUBSCRIBER ID", @r.L837.L2010BA.NM1.IdentificationCode.to_s)
  end

  def test_claims
    assert_equal("CLM*PATIENT ACCOUNT NUMBER*195***11::1*Y*A*Y*Y*C******P~",@r.L837.L2300.CLM.to_s)
    assert_equal("DTP*454*D8*20090701~", @r.L837.L2300.DTP[0].to_s)
  end

  def test_service_line
    assert_equal("LX*1~",@r.L837.L2400[0].LX.to_s)
    assert_equal("LX*2~",@r.L837.L2400[1].LX.to_s)
    assert_equal("LX*3~",@r.L837.L2400[2].LX.to_s)
  end

  def test_timing
    start = Time::now
    X12::TEST_REPEAT.times do
      @r = @parser.parse('837p', @msg[1])
    end
    finish = Time::now
    puts sprintf("Parses per second, 837p: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing
end

