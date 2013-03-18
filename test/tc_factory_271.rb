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
  RESULT = "ST*271*00001~ 
BHT*0022*11**20020202*0800*~ 
HL*1**20*1~ 
NM1*P5*2*CHILDRENS SPECIAL HEALTH 
CARE*****FI*356000158**~ 
PER*IC*CHILDRENS SPECIAL HEALTH 
CARE*TE*8004751355*TE*3172331351~ 
HL*2*1*21*1~ 
NM1*1P*2*Mayberry******SV*123456**~ 
AAA*N**51*C~ (Only if a 270 receiver error occurred)
HL*3*2*22*0~ 
TRN*2*98765-12345*9876543210*~ 
NM1*IL*1*Doe*Jane*A***MI*123456**~ 
REF*SY*123456789**~ 
N3*1234 Meridian*Apt 1E~ 
N4*Indianapolis*IN*46205***~ 
AAA*N**71*C~ (Only if a 270 subscriber error occurred)
DMG*D8*19500204*******~ 
DTP*307*RD8*20021201-20021231~ 
EB*1*IND*30**********~ 
REF*IG*123456789**~ 
SE*20*00001~"
  
  
  def setup    
    # result message that we are building and will test against 
    @result = RESULT
    # make the result usable in the tests
    @result.gsub!(/\n/,'')

#    @parser = X12::Parser.new('271.xml')
  end
 
  
  def teardown
    #nothing
  end
 
  
  def test_all
#    @p = @parser.factory('271')
    
    # build the message
    
    
    # compare the built message to the result
#    assert_equal(@result, @p.render)
  end

end
