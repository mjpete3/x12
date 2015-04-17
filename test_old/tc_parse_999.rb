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

class Test999Parse < Test::Unit::TestCase

  def setup
    @parser = X12::Parser.new('999.xml')
    @msg =[]
    @msg.push "ISA*00*          *00*          *27*PPPPPP         *27*XXXXXX         *100914*1025*^*00501*000000218*0*T*:~GS*FA*PPPPPP*XXXXXX*20100914*10251463*3*X*005010X231A1~ST*999*3001*005010X231A1~AK1*HC*2145001*005010X222A1~AK2*837*000000001*005010X222A1~IK5*A~AK9*A*1*1*1~SE*6*3001~GE*1*3~IEA*1*000000218~"
    @msg.push "ISA*00*          *00*          *ZZ*123456789      *ZZ*987654321      *041117*1024*^*00501*000000286*0*P*:~GS*FA*RCVR*SNDR*20041117*1024*287*X*005010X231~ST*999*2870001*005010X231~AK1*HC*17456*004010X098A1~AK2*837*0001~IK5*A~AK2*837*0002~IK3*CLM*22**8~CTX*CLM01:123456789~IK4*2*782*1~IK5*R*5~AK2*837*0003~IK3*REF*57**3~CTX*SITUATIONAL TRIGGER*CLM*43**5:3*C023:1325~CTX*CLM01:987654321~IK5*R*5~AK9*P*3*3*1~SE*16*2870001~GE*1*287~IEA*1*000000286~"
    # with TA1 interchange acknowledgment
    @msg.push "ISA*00*          *00*          *ZZ*330897513      *ZZ*593792225      *140421*0812*^*00501*004211112*0*P*:~TA1*004211112*140421*0812*A*000~GS*FA*330897513*593792225*20140421*0812*184911116*X*005010X231A1~ST*999*0001*005010X231A1~AK1*HC*4211112*005010X222A1~AK2*837*000000001*005010X222A1~IK5*A~AK2*837*000000002*005010X222A1~IK5*A~AK2*837*000000003*005010X222A1~IK5*A~AK2*837*000000004*005010X222A1~IK5*A~AK2*837*000000005*005010X222A1~IK5*A~AK2*837*000000006*005010X222A1~IK5*A~AK2*837*000000007*005010X222A1~IK5*A~AK2*837*000000008*005010X222A1~IK5*A~AK2*837*000000009*005010X222A1~IK5*A~AK2*837*000000010*005010X222A1~IK5*A~AK2*837*000000011*005010X222A1~IK5*A~AK2*837*000000012*005010X222A1~IK5*A~AK2*837*000000013*005010X222A1~IK5*A~AK2*837*000000014*005010X222A1~IK5*A~AK2*837*000000015*005010X222A1~IK5*A~AK2*837*000000016*005010X222A1~IK5*A~AK2*837*000000017*005010X222A1~IK5*A~AK2*837*000000018*005010X222A1~IK5*A~AK2*837*000000019*005010X222A1~IK5*A~AK2*837*000000020*005010X222A1~IK5*A~AK2*837*000000021*005010X222A1~IK5*A~AK2*837*000000022*005010X222A1~IK5*A~AK2*837*000000023*005010X222A1~IK5*A~AK2*837*000000024*005010X222A1~IK5*A~AK2*837*000000025*005010X222A1~IK5*A~AK2*837*000000026*005010X222A1~IK5*A~AK2*837*000000027*005010X222A1~IK5*A~AK2*837*000000028*005010X222A1~IK5*A~AK2*837*000000029*005010X222A1~IK5*A~AK2*837*000000030*005010X222A1~IK5*A~AK2*837*000000031*005010X222A1~IK5*A~AK2*837*000000032*005010X222A1~IK5*A~AK2*837*000000033*005010X222A1~IK5*A~AK2*837*000000034*005010X222A1~IK5*A~AK9*A*34*34*34~SE*72*0001~GE*1*184911116~IEA*1*004211112~"
  end

  def teardown
    #nothing
  end

  #parse a simple accepted message
  def test_simple
    @r = @parser.parse('999', @msg[0])

    assert_equal(@r.GS.ApplicationSendersCode, "PPPPPP")
    assert_equal(@r.GS.ApplicationReceiversCode, "XXXXXX")

    @r.L1000 {|a|
      assert_equal(a.AK2.TransactionSetIdentifierCode, "837")
      assert_equal(a.AK2.TransactionSetControlNumber, "000000001")
      assert_equal(a.AK2.ImplementationConventionReference, "005010X222A1")
      assert_equal(a.IK5.TransactionSetAcknowledgmentCode, "A")
    }
  end

  #parse a multiple transaction with 1 accepted and 2 rejected claims
  def test_msg2
    @r = @parser.parse('999', @msg[1])
    assert_equal(3, @r.L1000.size)
    assert_equal("A", @r.L1000[0].IK5.TransactionSetAcknowledgmentCode)
    assert_equal("R", @r.L1000[1].IK5.TransactionSetAcknowledgmentCode)
    assert_equal("R", @r.L1000[2].IK5.TransactionSetAcknowledgmentCode)
  end


  def test_msg3
    @r = @parser.parse('999', @msg[2])

    assert_equal(@r.TA1.InterchangeControlNumber, "004211112")
    assert_equal(@r.TA1.InterchangeAcknowledgmentCode, "A")
    assert_equal(@r.TA1.InterchangeNoteCode, "000")

    # there are 34 acknowledgments
    assert_equal(34, @r.L1000.size)
    assert_equal("A", @r.L1000[0].IK5.TransactionSetAcknowledgmentCode)
  end


  def test_timing
    start = Time::now
    X12::TEST_REPEAT.times do
      @r = @parser.parse('999', @msg[1])
    end
    finish = Time::now
    puts sprintf("Parses per second, 999: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  end # test_timing

end