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
# $Id: X12.rb 91 2009-05-13 22:11:10Z ikk $
#
# Package implementing direct manipulation of X12 structures using Ruby syntax.

require "x12/version"
require 'x12/base'
require 'x12/empty'
require 'x12/field'
require 'x12/composite'
require 'x12/segment'
require 'x12/table'
require 'x12/loop'
require 'x12/xmldefinitions'
require 'x12/parser'

module X12
  EMPTY = Empty.new()
  TEST_REPEAT = 100
end