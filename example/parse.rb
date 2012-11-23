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

# Define a test message to parse
m997='ST*997*2878~AK1*HS*293328532~AK2*270*307272179~'\
'AK3*NM1*8*L1010_0*8~AK4*0:0*66*1~AK4*0:1*66*1~AK4*0:2*'\
'66*1~AK3*NM1*8*L1010_1*8~AK4*1:0*66*1~AK4*1:1*66*1~AK3*'\
'NM1*8*L1010_2*8~AK4*2:0*66*1~AK5*R*5~AK9*R*1*1*0~SE*8*2878~'

# Parse the message
r = parser.parse('997', m997)
r.show

# Access components of the message as desired

# Whole ST segment: -> ST*997*2878~
puts r.ST

# One filed, Group Control Number of AK1 -> 293328532
puts r.AK1.GroupControlNumber

# Individual loop, namely, third L1010 subloop of
# L1000 loop: -> AK3*NM1*8*L1010_2*8~AK4*2:0*66*1~
puts r.L1000.L1010[2]

# First encounter of Data Element Reference Number of the 
# first L1010 sub-loop of L1000 loop -> 66
puts r.L1000.L1010.AK4.DataElementReferenceNumber

# Number of L1010 sub-loops in L1000 loop -> 3
puts r.L1000.L1010.size
