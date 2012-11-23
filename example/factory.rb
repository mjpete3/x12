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

# Read message definition and create an actual parser
# by compiling .d12 file
parser = X12::Parser.new('misc/997single.xml')

# Make a new 997 message 
r = parser.factory('997')

#
# Set various fields as desired
#

# Set fields directly
r.ST.TransactionSetIdentifierCode = 997
r.ST.TransactionSetControlNumber  = '2878'

# Set fields inside a segment (AK1 in this case)
r.AK1 { |ak1|
  ak1.FunctionalIdentifierCode = 'HS'
  ak1.GroupControlNumber       = 293328532
}

# Set fields deeply inside a segment inside 
# nested loops (L1000/L1010/AK4 in this case)
r.L1000.L1010.AK4.DataElementSyntaxErrorCode = 55
r.L1000.AK2.TransactionSetIdentifierCode     = 270

# Set nested loops
r.L1000.L1010 {|l|
  l.AK3 {|s|
    s.SegmentIdCode      = 'NM1'
    s.LoopIdentifierCode = 'L1000D'
  }
  l.AK4 {|s|
    s.CopyOfBadDataElement = 'Bad element'
  }
}

# Add loop repeats
r.L1000.repeat {|l1000|
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
          s.DataElementSyntaxErrorCode = ak4_repeat
        } # s
      } # ak4_repeat
    } # l1010
  } # loop_repeat

  l1000.AK5{|a|
    a.TransactionSetAcknowledgmentCode = 666
    a.TransactionSetSyntaxErrorCode4   = 999
  } # a
} # l1000

# Print the message as a string -> ST*997*2878~AK1*HS*293328532~
# AK2*270*~AK3*NM1**L1000D~AK4***55*Bad element~AK5*~AK3*DMG*0*
# L1010*22~AK4*0**0~AK4*0**1~AK4*1**0~AK4*1**1~AK5*666****999~
# AK9****~SE**~
puts r.render
