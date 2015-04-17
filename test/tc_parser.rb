#--
#     This file is part of the X12Parser library that provides tools to
#     manipulate X12 messages using Ruby native syntax.
#
#     http://x12parser.rubyforge.org
#
#     Copyright (C) 2014 P&D Technology Solutions, Inc.
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

class TestParser < Test::Unit::TestCase


  def setup
    @msg = "CLM*Me*mine*1:2:3*Yoyo~"                  
    @parser = X12::Parser.new('test_case.xml')    
  end # setup
  
  
  def test_parse    
      @r = @parser.parse('TEST', @msg)
      
      @r.show
  end
  
  
end # end test parser