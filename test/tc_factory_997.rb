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

class Test997Factory < Test::Unit::TestCase

  @@p = nil
tmp=<<-EOT
ST*997*2878~
AK1*HS*293328532~
AK2*270*~
AK3*NM1**L1000D~
AK4***55*Bad element~
AK5*A~
AK3*DMG*0*L1010*22~
AK4*0**0~
AK4*0**1~
AK4*1**0~
AK4*1**1~
AK5*E****999~
AK9****~
SE**~
EOT

  @@result = tmp.gsub!(/\n/,'')

  def setup
    unless @@p
      # @@p = X12::Parser.new('misc/997single.xml')
      @@p = X12::Parser.new('misc/997.xml')
    end
  end # setup

  def teardown
    # Nothing
  end # teardown

  def test_all
    @r = @@p.factory('997')

    @r.ST.TransactionSetIdentifierCode = 997
    @r.ST.TransactionSetControlNumber  = '2878'

    @r.AK1 { |ak1|
      ak1.FunctionalIdentifierCode = 'HS'
      ak1.GroupControlNumber       = 293328532
    }

    @r.L1000.L1010.AK4.DataElementSyntaxErrorCode=55
    @r.L1000.AK2.TransactionSetIdentifierCode = 270
    @r.L1000.L1010 {|l|
      l.AK3 {|s|
        s.SegmentIdCode                   = 'NM1'
        #SegmentPositionInTransactionSet
        s.LoopIdentifierCode              = 'L1000D'
        #SegmentSyntaxErrorCode
      }

      l.AK4 {|s|
        #s.PositionInSegment =
        #s.DataElementReferenceNumber =
        #s.DataElementSyntaxErrorCode = 
        s.CopyOfBadDataElement       = 'Bad element'
      }
    }

    @r.L1000.AK5{|a|
      a.TransactionSetAcknowledgmentCode = 'A'
    } # a

    # Should be two repeats in total
    @r.L1000.repeat {|l1000|
      (0..1).each {|loop_repeat| # Two repeats of the loop L1010
        l1000.L1010.repeat {|l1010|

          l1010.AK3 {|s|
            s.SegmentIdCode                   = 'DMG'
            s.SegmentPositionInTransactionSet = 0
            s.LoopIdentifierCode              = 'L1010'
            s.SegmentSyntaxErrorCode          = 22
          } if loop_repeat == 0 # AK3 only in the first repeat of L1010

          (0..1).each {|ak4_repeat| # Two repeats of the segment AK4
            l1010.AK4.repeat {|s|
              s.PositionInSegment          = loop_repeat
              #s.DataElementReferenceNumber = 
              s.DataElementSyntaxErrorCode = ak4_repeat
              #s.CopyOfBadDataElement       =
            } # s
          } # ak4_repeat
        } # l1010
      } # loop_repeat

      l1000.AK5{|a|
        a.TransactionSetAcknowledgmentCode = 'E'
        a.TransactionSetSyntaxErrorCode4 = 999
      } # a
    } # l1000

    assert_equal(@@result, @r.render)
  end # test_all

  def test_timing
    start = Time::now
    X12::TEST_REPEAT.times do
      test_all
    end
    finish = Time::now
    puts sprintf("Factories per second, 997: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing

end # TestList
