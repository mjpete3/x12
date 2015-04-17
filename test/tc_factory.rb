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

class TestFactory < Test::Unit::TestCase


  def setup
    @result_render = "CLM*Me*mine*1:2:3*Yoyo~"          
    @result_show = "TEST [0]: \n  CLM [0]: \n    First -> 'Me'\n    Second -> 'mine'\n    COMP [0]: \n      CFirst -> '1'\n      CSecond -> '2'\n      CThird -> '3'\n    Third -> 'Yoyo'\n"
    
    @p = X12::Parser.new('test_case.xml')    
  end # setup


  def teardown
    # Nothing
  end # teardown

  
  def test_accessors
    @r = @p.factory('TEST')
    @r.CLM.First = "Me" 
    @r.CLM.Second = "mine"
    @r.CLM.Third = "Yoyo"
    @r.CLM.COMP.CFirst = "1"
    @r.CLM.COMP.CSecond = "2"
    @r.CLM.COMP.CThird = "3"

    assert_equal @r.CLM.First, "Me"
    assert_equal @r.CLM.Third, "Yoyo"
    assert_equal @r.CLM.COMP.CFirst, "1"        
  end
  
  
  def test_render
    @r = @p.factory('TEST')
    @r.CLM.First = "Me" 
    @r.CLM.Second = "mine"
    @r.CLM.Third = "Yoyo"
    @r.CLM.COMP.CFirst = "1"
    @r.CLM.COMP.CSecond = "2"
    @r.CLM.COMP.CThird = "3"
    
    assert_equal @result_render, @r.render
  end
  
  
  def test_show
    @r = @p.factory('TEST')
    @r.CLM.First = "Me" 
    @r.CLM.Second = "mine"
    @r.CLM.Third = "Yoyo"
    @r.CLM.COMP.CFirst = "1"
    @r.CLM.COMP.CSecond = "2"
    @r.CLM.COMP.CThird = "3"

    assert_equal @result_show, with_captured_stdout {@r.show}
  end


  private 
    
  def with_captured_stdout
    begin
      old_stdout = $stdout
      $stdout = StringIO.new('','w')
      yield
      $stdout.string
    ensure
      $stdout = old_stdout
    end
  end
end # TestComposite
