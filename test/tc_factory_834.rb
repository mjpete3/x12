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

class Test834Factory < Test::Unit::TestCase

  RESULT="ISA*00*          *00*          *01*9012345720000  *01*9088877320000  *100822*1134*U*00200*000000007*0*T*:~
GS*BE*901234572000*908887732000*20100822*1615*7*X*005010X220A1~
ST*834*0007*005010X220A1~
BGN*00*0*20110101*160135****4~
REF*38*0~
N1*P5*FOO A*FI*990999999~
N1*IN*FOO B*FI*993999999~
N1*TV*FOO C*FI*997999999~
INS*Y*18*030*XN*A*E**FT~
REF*OF*152239999~
REF*1L*Blue~
DTP*336*D8*20070101~
NM1*IL*1*BLUTH*LUCILLE****34*152239999~
N3*224 N DES PLAINES*6TH FLOOR~
N4*CHICAGO*IL*60661*USA~
DMG*D8*19720121*F*M~
HD*030**VIS*Vision Plan*EMP~
DTP*348*D8*20111016~
SE*16*0007~
GE*1*7~
IEA*1*000000007~"

  def setup
    @result = RESULT
    @result.gsub!(/\n/,'')

    @parser = X12::Parser.new('834.xml')
  end

  def teardown
    #nothing
  end

  def segment_nm1(nm1, code1, code2, code3, code4, code5, code6, code7, code8, code9)
    nm1.EntityIdentifierCode1 = code1
    nm1.EntityTypeQualifier = code2
    nm1.NameLastOrOrganizationName = code3
    nm1.NameFirst = code4
    nm1.NameMiddle = code5
    nm1.NamePrefix = code6
    nm1.NameSuffix = code7
    nm1.IdentificationCodeQualifier = code8
    nm1.IdentificationCode = code9
  end

  def segment_n3(n3, code1, code2)
    n3.AddressInformation1 = code1
    if code2 != ""
      n3.AddressInformation2 = code2
    end
  end

  def segment_n4(n4, code1, code2, code3)
    n4.CityName = code1
    n4.StateOrProvinceCode = code2
    n4.PostalCode = code3
  end

  def loop_l1000a(loop)
    loop.N1 { |n|
      n.EntityIdentifierCode1 = "P5"
      n.Name = "FOO A"
      n.IdentificationCodeQualifier = "FI"
      n.IdentificationCode = "990999999"
      }
  end

  def loop_l1000b(loop)
    loop.N1 { |n|
      n.EntityIdentifierCode1 = "IN"
      n.Name = "FOO B"
      n.IdentificationCodeQualifier = "FI"
      n.IdentificationCode = "993999999"
      }
  end

  def loop_l1000c(loop)
    loop.N1 { |n|
      n.EntityIdentifierCode1 = "TV"
      n.Name = "FOO C"
      n.IdentificationCodeQualifier = "FI"
      n.IdentificationCode = "997999999"
      }
  end

  def loop_l2000(loop)
    loop.INS { |ins|
      ins.YesNoConditionOrResponseCode1 = 'Y'
      ins.IndividualRelationshipCode = '18'
      ins.MaintenanceTypeCode = '030'
      ins.MaintenanceReasonCode = 'XN'
      ins.BenefitStatusCode = 'A'
      ins.MedicareStatusCode = 'E'
      ins.EmploymentStatusCode = 'FT'
    }
    loop.REF.repeat do |r|
      r.ReferenceIdentificationQualifier = 'OF'
      r.ReferenceIdentification = '152239999'
      # This is only nessessary because we have two REF lines within the same loop.
      #TODO: Find better solution than compound REF Segments.
      r.repeat do |x|
        x.ReferenceIdentificationQualifier = '1L'
        x.ReferenceIdentification = 'Blue'
      end
    end
    loop.DTP { |dtp|
      dtp.DateTimeQualifier = '336'
      dtp.DateTimePeriodFormatQualifier = 'D8'
      dtp.DateTimePeriod = '20070101'
    }
  end

  def loop_l2100a(loop)
    loop.NM1 { |nm1|
      nm1.EntityIdentifierCode1 = 'IL'
      nm1.EntityTypeQualifier = '1'
      nm1.NameLastOrOrganizationName = 'BLUTH'
      nm1.NameFirst = 'LUCILLE'
      nm1.IdentificationCodeQualifier = '34'
      nm1.IdentificationCode = '152239999'
    }
    loop.N3 { |n|
      n.AddressInformation1 = '224 N DES PLAINES'
      n.AddressInformation2 = '6TH FLOOR'
    }
    loop.N4 { |n|
      n.CityName = 'CHICAGO'
      n.StateOrProvinceCode = 'IL'
      n.PostalCode = '60661'
      n.CountryCode = 'USA'
    }
    loop.DMG { |dmg|
      dmg.DateTimePeriodFormatQualifier = 'D8'
      dmg.DateTimePeriod = '19720121'
      dmg.GenderCode = 'F'
      dmg.MaritalStatusCode = 'M'
    }
  end

  def test_all
    @r = @parser.factory('834')
    count = 0

    @r.ISA { |isa|
      isa.AuthorizationInformationQualifier = '00'
      isa.AuthorizationInformation = '          '
      isa.SecurityInformationQualifier = '00'
      isa.SecurityInformation = '          '
      isa.InterchangeIdQualifier1 = '01'
      isa.InterchangeSenderId = '9012345720000 '
      isa.InterchangeIdQualifier2 = '01'
      isa.InterchangeReceiverId = '9088877320000'
      isa.InterchangeDate = '100822'
      isa.InterchangeTime = '1134'
      isa.InterchangeControlStandardsIdentifier = 'U'
      isa.InterchangeControlVersionNumber = '00200'
      isa.InterchangeControlNumber = '000000007'
      isa.AcknowledgmentRequested = '0'
      isa.UsageIndicator = 'T'
      isa.ComponentElementSeparator = ':'
    }
    @r.GS { |gs|
      gs.FunctionalIdentifierCode = 'BE'
      gs.ApplicationSendersCode = '901234572000'
      gs.ApplicationReceiversCode = '908887732000'
      gs.Date = '20100822'
      gs.Time = '1615'
      gs.GroupControlNumber = '7'
      gs.ResponsibleAgencyCode = 'X'
      gs.VersionReleaseIndustryIdentifierCode = '005010X220A1'
    }

    @r.ST.TransactionSetIdentifierCode = '834'
    @r.ST.TransactionSetControlNumber  = '0007'
    @r.ST.ImplementationConventionReference = '005010X220A1'
    count += 1
    @r.BGN.TransactionSetPurposeCode = '00'
    @r.BGN.ReferenceIdentification1 = '0'
    @r.BGN.Date = '20110101'
    @r.BGN.Time = '160135'
    @r.BGN.ActionCode ='4'
    count += 1

    @r.REF.ReferenceIdentificationQualifier = '38'
    @r.REF.ReferenceIdentification = '0'
    count += 1

    loop_l1000a(@r.L1000A)
    count += 1

    loop_l1000b(@r.L1000B)
    count += 1

    loop_l1000c(@r.L1000C)
    count += 1

    loop_l2000(@r.L2000)
    count += 3

    loop_l2100a(@r.L2100A)
    count += 4

    @r.L2300.HD { |hd|
      hd.MaintenanceTypeCode = '030'
      hd.InsuranceLineCode = 'VIS'
      hd.PlanCoverageDescription = 'Vision Plan'
      hd.CoverageLevelCode = 'EMP'
    }
    @r.L2300.DTP { |dtp|
      dtp.DateTimeQualifier = '348'
      dtp.DateTimePeriodFormatQualifier = 'D8'
      dtp.DateTimePeriod = '20111016'
    }
    count += 2

    @r.SE.NumberOfIncludedSegments = count + 1
    @r.SE.TransactionSetControlNumber  = '0007'

    @r.GE.NumberOfTransactionSetsIncluded = 1
    @r.GE.GroupControlNumber = 7

    @r.IEA.NumberOfIncludedFunctionalGroups = '1'
    @r.IEA.InterchangeControlNumber = '000000007'

    assert_equal(@result, @r.render)
  end

  def test_timing
    start = Time::now
    X12::TEST_REPEAT.times do
      test_all
    end
    finish = Time::now
    puts sprintf("Factories per second, 834: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing

end
