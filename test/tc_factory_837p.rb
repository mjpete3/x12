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

class Test837pFactory < Test::Unit::TestCase

  RESULT = "ISA*00*          *00*          *01*9012345720000  *01*9088877320000  *100822*1134*U*00200*000000007*0*T*:~
GS*HC*901234572000*908887732000*20100822*1615*7*X*005010X222~
ST*837*0007*005010X222~
BHT*0019*00*123BATCH*20100822*1615*CH~
NM1*41*2*ABC CLEARINGHOUSE*****46*123456789~
PER*IC*WILMA FLINSTONE*TE*9195551111~
NM1*40*2*BCBSNC*****46*987654321~
HL*1* *20*1~
NM1*85*1*SMITH*ELIZABETH*A**M.D.*XX*0123456789~
N3*123 MUDD LANE~
N4*DURHAM*NC*27701~
REF*EI*123456789~
HL*2*1*22*0~
SBR*P*18*ABC123101******BL~
NM1*IL*1*DOUGH*MARY*B***MI*24670389600~
N3*P O BOX 12312~
N4*DURHAM*NC*27715~
DMG*D8*19670807*F~
NM1*PR*2*BCBSNC*****PI*987654321~
CLM*PTACCT2235057*100.5***11::1*Y*A*Y*N~
REF*EA*MEDREC11111~
HI*BK:78901~
LX*1~
SV1*HC:99212*100.5*UN*1*12**1**N~
DTP*472*D8*20100801~
SE*24*0007~
GE*1*7~
IEA*1*000000007~"

  def setup
    @result = RESULT
    @result.gsub!(/\n/,'')

    @parser = X12::Parser.new('837p.xml')
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
    segment_nm1(loop.NM1,"41","2","ABC CLEARINGHOUSE","","","","","46","123456789")
    loop.PER {|p|
      p.ContactFunctionCode = "IC"
      p.Name = "WILMA FLINSTONE"
      p.CommunicationNumberQualifier1 = "TE"
      p.CommunicationNumber1 = "9195551111"
      }
  end

  def loop_l1000b(loop)
    segment_nm1(loop.NM1,"40","2","BCBSNC","","","","","46","987654321")
  end

  def loop_l2000a(loop)
    loop.HL { |h|
      h.HierarchicalIdNumber = "1"
      h.HierarchicalLevelCode = "20"
      h.HierarchicalChildCode = "1"
    }
  end

  def loop_l2010aa(loop)
    segment_nm1(loop.NM1,"85","1","SMITH","ELIZABETH","A","","M.D.","XX","0123456789")
    segment_n3(loop.N3,"123 MUDD LANE","")
    segment_n4(loop.N4,"DURHAM","NC","27701")

    loop.REF {|r|
      r.ReferenceIdentificationQualifier = "EI"
      r.ReferenceIdentification = "123456789"
  }
  end

  def loop_l2000b(loop)
    loop.HL { |h|
      h.HierarchicalIdNumber = "2"
      h.HierarchicalParentIdNumber = "1"
      h.HierarchicalLevelCode = "22"
      h.HierarchicalChildCode = "0"
    }
    loop.SBR {|s|
      s.PayerResponsibilitySequenceNumberCode = "P"
      s.IndividualRelationshipCode = "18"
      s.InsuredGroupOrPolicyNumber = "ABC123101"
      s.ClaimFilingIndicatorCode = "BL"
    }

  end

  def loop_l2010ba(loop)
    segment_nm1(loop.NM1,"IL","1","DOUGH","MARY","B","","","MI","24670389600")
    segment_n3(loop.N3, "P O BOX 12312", "")
    segment_n4(loop.N4,"DURHAM","NC","27715")
    loop.DMG {|d|
      d.DateTimePeriodFormatQualifier = "D8"
      d.DateTimePeriod = "19670807"
      d.GenderCode = "F"
    }

  end

  def loop_l2010bb(loop)
    segment_nm1(loop.NM1,"PR","2","BCBSNC","","","","","PI","987654321")
  end

  def loop_l2300(loop)
    loop.CLM {|c|
      c.PatientAccountNumber = "PTACCT2235057"
      c.MonetaryAmount = "100.5"
      c.HealthCareServiceLocationInformation = "11::1"
      c.ProviderOrSupplierSignatureIndicator = "Y"
      c.MedicareAssignmentCode = "A"
      c.BenefitsAssignmentCertificationIndicator = "Y"
      c.ReleaseOfInformationCode = "N"
    }

    loop.REF {|r|
      r.ReferenceIdentificationQualifier = "EA"
      r.ReferenceIdentification = "MEDREC11111"
    }

    loop.HI.HealthCareCodeInformation1 = "BK:78901"
  end

  def loop_l2400(loop)
    loop.LX.AssignedNumber = "1"
    loop.SV1 {|s|
      s.CompositeMedicalProcedureIdentifier = "HC:99212"
      s.LineItemChargeAmount = "100.5"
      s.UnitOrBasisForMeasurementCode = "UN"
      s.ServiceUnitAmount = "1"
      s.PlaceOfServiceCode = "12"
      s.CompositeDiagnosisCodePointer = "1"
      s.EmergencyIndicator = "N"
    }

    loop.DTP {|d|
      d.DateTimeQualifier = "472"
      d.DateTimePeriodFormatQualifier = "D8"
      d.DateTimePeriod = "20100801"
    }
  end


  def test_all
    @r = @parser.factory('837p')
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

    @r.GS {|gs|
      gs.FunctionalIdentifierCode = 'HC'
      gs.ApplicationSendersCode = '901234572000'
      gs.ApplicationReceiversCode = '908887732000'
      gs.Date = '20100822'
      gs.Time = '1615'
      gs.GroupControlNumber = '7'
      gs.ResponsibleAgencyCode = 'X'
      gs.VersionReleaseIndustryIdentifierCode = '005010X222'
      }

    @r.ST.TransactionSetIdentifierCode = '837'
    @r.ST.TransactionSetControlNumber  = '0007'
    @r.ST.ImplementationConventionReference = '005010X222'
    count += 1

    @r.BHT.HierarchicalStructureCode = '0019'
    @r.BHT.TransactionSetPurposeCode = '00'
    @r.BHT.ReferenceIdentification = '123BATCH'
    @r.BHT.Date = '20100822'
    @r.BHT.Time = '1615'
    @r.BHT.TransactionTypeCode = 'CH'
    count += 1

    loop_l1000a(@r.L1000A)
    count += 2
    loop_l1000b(@r.L1000B)
    count += 1
    loop_l2000a(@r.L2000A)
    count += 1
    loop_l2010aa(@r.L2010AA)
    count += 4
    loop_l2000b(@r.L2000B)
    count += 2
    loop_l2010ba(@r.L2010BA)
    count += 4
    loop_l2010bb(@r.L2010BB)
    count += 1
    loop_l2300(@r.L2300)
    count += 3
    loop_l2400(@r.L2400)
    count += 3

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
    puts sprintf("Factories per second, 837p: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing

end
