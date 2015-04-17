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

class Test271Factory < Test::Unit::TestCase

  #message in readable format
  RESULT = "ISA*00*0000000000*00*0000000000*ZZ*610017         *ZZ*T0001799       *030430*1700*U*00401*000000157*0*P*:~
GS*HB*610017*T0001799*20030430*1700190*1570001*X*004010X092A1~
ST*271*0001~
BHT*0022*11*270-001-AK*20030430*1700~
HL*1* *20*1~
NM1*PR*2*BCBSRI*****PI*00870~
HL*2*1*21*1~
NM1*1P*1*DOE*JOHN****XX*NPI#~
REF*N5*0000099818~
HL*3*2*22*0~
TRN*2*100-270-001-AK*9050469595~
NM1*IL*1*DOE*ROBERT****MI*BP10375089330~
N3*80 GREEN STREET~
N4*WOONSOCKET*RI*02895~
DMG*D8*19801130*M~
EB*R*   *30~
SE*15*0001~
GE*1*1570001~
IEA*1*000000157~"


  def setup
    # result message that we are building and will test against
    @result = RESULT
    # make the result usable in the tests
    @result.gsub!(/\n/,'')

    @parser = X12::Parser.new('271.xml')
  end


  def teardown
    #nothing
  end


  def test_all
    @r = @parser.factory('271')
    count = 0

    @r.ISA { |isa|
      isa.AuthorizationInformationQualifier = '00'
      isa.AuthorizationInformation = '0000000000'
      isa.SecurityInformationQualifier = '00'
      isa.SecurityInformation = '0000000000'
      isa.InterchangeIdQualifier1 = 'ZZ'
      isa.InterchangeSenderId = '610017 '
      isa.InterchangeIdQualifier2 = 'ZZ'
      isa.InterchangeReceiverId = 'T0001799'
      isa.InterchangeDate = '030430'
      isa.InterchangeTime = '1700'
      isa.InterchangeControlStandardsIdentifier = 'U'
      isa.InterchangeControlVersionNumber = '00401'
      isa.InterchangeControlNumber = '000000157'
      isa.AcknowledgmentRequested = '0'
      isa.UsageIndicator = 'P'
      isa.ComponentElementSeparator = ':'
    }

    @r.GS {|gs|
      gs.FunctionalIdentifierCode = 'HB'
      gs.ApplicationSendersCode = '610017'
      gs.ApplicationReceiversCode = 'T0001799'
      gs.Date = '20030430'
      gs.Time = '1700190'
      gs.GroupControlNumber = '1570001'
      gs.ResponsibleAgencyCode = 'X'
      gs.VersionReleaseIndustryIdentifierCode = '004010X092A1'
      }

    # build the message
    @r.ST.TransactionSetIdentifierCode = '271'
    @r.ST.TransactionSetControlNumber = '0001'
    count += 1

    @r.BHT {|bht|
      bht.HierarchicalStructureCode='0022'
      bht.TransactionSetPurposeCode='11'
      bht.ReferenceIdentification="270-001-AK"
      bht.Date='20030430'
      bht.Time='1700'
    }
    count += 1

    @r.L2000A.HL {|hl|
      hl.HierarchicalIdNumber="1"
      hl.HierarchicalParentIdNumber=""
      hl.HierarchicalLevelCode="20"
      hl.HierarchicalChildCode="1"
      }
    count += 1

    @r.L2100A.NM1 {|nm1|
      nm1.EntityIdentifierCode1="PR"
      nm1.EntityTypeQualifier="2"
      nm1.NameLastOrOrganizationName="BCBSRI"
      nm1.NameFirst=""
      nm1.NameMiddle=""
      nm1.NamePrefix=""
      nm1.NameSuffix=""
      nm1.IdentificationCodeQualifier="PI"
      nm1.IdentificationCode="00870"
      }
    count += 1

    @r.L2000B.HL {|hl|
      hl.HierarchicalIdNumber="2"
      hl.HierarchicalParentIdNumber="1"
      hl.HierarchicalLevelCode="21"
      hl.HierarchicalChildCode="1"
      }
    count += 1

    @r.L2100B.NM1 {|nm1|
      nm1.EntityIdentifierCode1="1P"
      nm1.EntityTypeQualifier="1"
      nm1.NameLastOrOrganizationName="DOE"
      nm1.NameFirst="JOHN"
      nm1.IdentificationCodeQualifier="XX"
      nm1.IdentificationCode="NPI#"
      }
    count += 1

    @r.L2100B.REF {|ref|
      ref.ReferenceIdentificationQualifier="N5"
      ref.ReferenceIdentification="0000099818"
      }
    count += 1

    @r.L2000C.HL {|hl|
      hl.HierarchicalIdNumber="3"
      hl.HierarchicalParentIdNumber="2"
      hl.HierarchicalLevelCode="22"
      hl.HierarchicalChildCode="0"
      }
    count += 1

    @r.L2000C.TRN {|trn|
      trn.TraceTypeCode="2"
      trn.ReferenceIdentification1="100-270-001-AK"
      trn.OriginatingCompanyIdentifier="9050469595"
      }
    count += 1

    @r.L2100C.NM1 {|nm1|
      nm1.EntityIdentifierCode1="IL"
      nm1.EntityTypeQualifier="1"
      nm1.NameLastOrOrganizationName="DOE"
      nm1.NameFirst="ROBERT"
      nm1.IdentificationCodeQualifier="MI"
      nm1.IdentificationCode="BP10375089330"
      }
    count += 1

    @r.L2100C.N3 {|n3|
      n3.AddressInformation1="80 GREEN STREET"
      }
    count += 1

    @r.L2100C.N4 {|n4|
      n4.CityName="WOONSOCKET"
      n4.StateOrProvinceCode="RI"
      n4.PostalCode="02895"
      }
    count += 1

    @r.L2100C.DMG {|dmg|
      dmg.DateTimePeriodFormatQualifier="D8"
      dmg.DateTimePeriod="19801130"
      dmg.GenderCode="M"
      }
    count += 1

    @r.L2110C.EB {|eb|
      eb.EligibilityOrBenefitInformation="R"
      eb.ServiceTypeCode="30"
      }
    count += 1

    count += 1
    @r.SE {|se|
      se.NumberOfIncludedSegments = count
      se.TransactionSetControlNumber = '0001'
    }

    @r.GE.NumberOfTransactionSetsIncluded = "1"
    @r.GE.GroupControlNumber = "1570001"

    @r.IEA.NumberOfIncludedFunctionalGroups = '1'
    @r.IEA.InterchangeControlNumber = '000000157'

    # compare the built message to the result
    assert_equal(@result, @r.render)
  end

  def test_timing
    start = Time::now
    X12::TEST_REPEAT.times do
      test_all
    end
    finish = Time::now
    puts sprintf("Factories per second, 271: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing


end
