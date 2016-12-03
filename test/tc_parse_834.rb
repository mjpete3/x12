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

class Test834Parse < Test::Unit::TestCase

  MESSAGE = "ISA*00*          *00*          *01*9012345720000  *01*9088877320000  *100822*1134*U*00200*000000007*0*T*:~
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

  MESSAGE1 = "ISA*00*          *00*          *01*9012345720000  *01*9088877320000  *100822*1134*U*00200*000000007*0*T*:~
GS*BE*901234572000*908887732000*20100822*1615*7*X*005010X2220A1~
ST*834*0007*005010X220A1~
INS*Y*18*030*XN*A*E**FT~
REF*OF*152239999~
REF*1L*Blue~
DTP*336*D8*20070101~
NM1*IL*1*BLUTH*LUCILLE****34*152239999~
N3*224 N DES PLAINES*6TH FLOOR~
N4*CHICAGO*IL*60661*USA~
DMG*D8*19720121*F*M~
HD*030**VIS**EMP~
DTP*348*D8*20111016~
INS*N*19*030*XN*A*E***N*N~
REF*OF*152239999~
REF*1L*Blue~
DTP*357*D8*20111015~
NM1*IL*1*BLUTH*BUSTER~
N3*224 N DES PLAINES*6TH FLOOR~
N4*CHICAGO*IL*60661*USA~
DMG*D**19911015*M-HD*030**VIS~
DTP*348*D8*20110101~
DTP*349*D8*20111015~
SE*24*0007~
GE*1*7~
IEA*1*000000007~"

  def setup
    # readable format
    @message = MESSAGE
    # make the result usable in the tests
    @message.gsub!(/\n/,'')

    @parser = X12::Parser.new('834.xml')
    @r = @parser.parse('834', @message)

    # second message for testing negatives
    @message1 = MESSAGE1
    @message1.gsub!(/\n/,'')
    @r1 = @parser.parse('834', @message1)
  end

  def teardown
    #nothing
  end

  def test_basic
    puts "Factory 276 - Need to build tests"
  end
end
