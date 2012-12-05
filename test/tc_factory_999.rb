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

class Test999Factory < Test::Unit::TestCase
  
  def setup
    @parser = X12::Parser.new('999.xml')
    @msg = "ISA*00*          *00*          *27*PPPPPP         *27*XXXXXX         *100914*1025*^*00501*000000218*0*T*:~GS*FA*PPPPPP*XXXXXX*20100914*10251463*3*X*005010X231A1~ST*999*3001*005010X231A1~AK1*HC*2145001*005010X222A1~AK2*837*000000001*005010X222A1~IK5*A~AK9*A*1*1*1~SE*6*3001~GE*1*3~IEA*1*000000218~"
  end
  
  def teardown
    #nothing  
  end
  
  def set_header(r)
    r.ISA.AuthorizationInformationQualifier = "00"
    r.ISA.AuthorizationInformation = "          "
    r.ISA.SecurityInformationQualifier = "00"
    r.ISA.SecurityInformation = "          "
    r.ISA.InterchangeIdQualifier1 = "27"
    r.ISA.InterchangeSenderId = "PPPPPP         "
    r.ISA.InterchangeIdQualifier2 = "27"
    r.ISA.InterchangeReceiverId = "XXXXXX         "
    r.ISA.InterchangeDate = "100914"
    r.ISA.InterchangeTime = "1025"
    r.ISA.InterchangeControlStandardsIdentifier = "^"
    r.ISA.InterchangeControlVersionNumber = "00501"
    r.ISA.InterchangeControlNumber = "000000218"
    r.ISA.AcknowledgmentRequested = "0"
    r.ISA.UsageIndicator = "T"
    r.ISA.ComponentElementSeparator = ":"   
    
    r.GS.FunctionalIdentifierCode = "FA" 
    r.GS.ApplicationSendersCode = "PPPPPP"
    r.GS.ApplicationReceiversCode = "XXXXXX"
    r.GS.Date = "20100914"
    r.GS.Time = "10251463"
    r.GS.GroupControlNumber = "3"
    r.GS.ResponsibleAgencyCode = "X"
    r.GS.VersionReleaseIndustryIdentifierCode = "005010X231A1" 
    
    r.ST.TransactionSetIdentifierCode = 999
    r.ST.TransactionSetControlNumber  = '3001'
    r.ST.ImplementationConventionReference = "005010X231A1"
    return r
  end
  
  def set_trailer(r, count)
    r.SE.NumberOfIncludedSegments = count
    r.SE.TransactionSetControlNumber = "3001"
    
    r.GE.NumberOfTransactionSetsIncluded = "1" 
    r.GE.GroupControlNumber = "3"
    
    r.IEA.NumberOfIncludedFunctionalGroups = "1"
    r.IEA.InterchangeControlNumber = "000000218"
    return r
  end
  
  def test_all
    @r = @parser.factory('999')
    @r = set_header(@r)
    #count both the ST and SE segments
    @seg_count = 2
    
    @r.AK1 {|a|
      a.FunctionalIdentifierCode = "HC"
      a.GroupControlNumber = "2145001"
      a.VersionReleaseIndustryIdentifierCode = "005010X222A1"
    }
    @seg_count += 1
    
    @r.L1000 {|a|
      a.AK2.TransactionSetIdentifierCode = "837"
      a.AK2.TransactionSetControlNumber = "000000001"
      a.AK2.ImplementationConventionReference = "005010X222A1"
      @seg_count += 1  
      a.IK5.TransactionSetAcknowledgmentCode = "A"
      @seg_count += 1
    }
    
    @r.AK9 {|a|
      a.FunctionalGroupAcknowledgeCode = "A"
      a.NumberOfTransactionSetsIncluded = "1"
      a.NumberOfReceivedTransactionSets = "1"
      a.NumberOfAcceptedTransactionSets = "1"
    }
    @seg_count += 1

    @r = set_trailer(@r, @seg_count)
    
    assert_equal(@msg, @r.render)
  end
  
  def test_timing
    start = Time::now
    X12::TEST_REPEAT.times do
      test_all
    end
    finish = Time::now
    puts sprintf("Factories per second, 999: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing
  
  
end