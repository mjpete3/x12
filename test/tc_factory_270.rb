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

class Test270Factory < Test::Unit::TestCase

  @@p = nil
@@result=<<-EOT
ST*270*1001~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*BIG PAYOR*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*Doe*Joe~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*1001~
EOT

  @@result.gsub!(/\n/,'')

  def setup
    unless @@p
      @@p = X12::Parser.new('misc/270.xml')
    end
  end # setup

  def teardown
    # Nothing
  end # teardown

  def test_all
    @r = @@p.factory('270')
    count = 0

    @r.ST.TransactionSetControlNumber  = '1001'
    count += 1

    @r.BHT {|bht|
      bht.HierarchicalStructureCode='0022'
      bht.TransactionSetPurposeCode='13'
      bht.ReferenceIdentification='LNKJNFGRWDLR'
      bht.Date='20070724'
      bht.Time='1726'
    }
    count += 1

    @r.L2000A {|l2000A|
      l2000A.HL{|hl|
        hl.HierarchicalIdNumber='1'
        hl.HierarchicalParentIdNumber=''
        hl.HierarchicalChildCode='1'
      }
      count += 1

      l2000A.L2100A {|l2100A|
        l2100A.NM1 {|nm1|
          nm1.EntityIdentifierCode1='PR'
          nm1.EntityTypeQualifier='2'
          nm1.NameLastOrOrganizationName='BIG PAYOR'
          nm1.IdentificationCodeQualifier='PI'
          nm1.IdentificationCode='CHICAGO BLUES'
        }
        count += 1
      }
    }

    @r.L2000B {|l2000B|
      l2000B.HL{|hl|
        hl.HierarchicalIdNumber='2'
        hl.HierarchicalParentIdNumber='1'
        hl.HierarchicalChildCode='1'
      }
      count += 1
      
      l2000B.L2100B {|l2100B|
        l2100B.NM1 {|nm1|
          nm1.EntityIdentifierCode1='1P'
          nm1.EntityTypeQualifier='1'
          nm1.NameLastOrOrganizationName=''
          nm1.IdentificationCodeQualifier='SV'
          nm1.IdentificationCode='daw'
        }
        count += 1
      }
    }

    @r.L2000C {|l2000C|
      l2000C.HL{|hl|
        hl.HierarchicalIdNumber='3'
        hl.HierarchicalParentIdNumber='2'
        hl.HierarchicalChildCode='0'
      }
      count += 1

      l2000C.L2100C {|l2100C|
        l2100C.NM1 {|nm1|
          nm1.EntityIdentifierCode1='IL'
          nm1.EntityTypeQualifier='1'
          nm1.NameLastOrOrganizationName='Doe'
          nm1.NameFirst='Joe'
        }
        count += 1

        l2100C.DMG {|dmg|
          dmg.DateTimePeriodFormatQualifier='D8'
          dmg.DateTimePeriod='19700725'
        }
        count += 1

        l2100C.DTP {|dtp|
          dtp.DateTimeQualifier='307'
          dtp.DateTimePeriodFormatQualifier='D8'
          dtp.DateTimePeriod='20070724'
        }
        count += 1

        l2100C.L2110C {|l2110C|
          l2110C.EQ {|eq|
            eq.ServiceTypeCode='60'
          }
          count += 1
        }
      }
    }

    count += 1
    @r.SE {|se|
      se.NumberOfIncludedSegments = count
      se.TransactionSetControlNumber = '1001'
    }

    assert_equal(@@result, @r.render)
  end # test_all

  def test_timing
    start = Time::now
    X12::TEST_REPEAT.times do
      test_all
    end
    finish = Time::now
    puts sprintf("Factories per second, 270: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing

end # TestList
