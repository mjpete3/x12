# X12

Current version has been upgraded to run under ruby version >= 1.9.1

Changes welcome, especially new document types or better tests.

# License

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

## Installation

Add this line to your application's Gemfile:

    gem 'PD_x12'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install PX_x12


# The goal

The idea is to access X12 messages directly from Ruby, i.e., using a syntax like

  message.L1000.L1010[1].AK4.DataElementReferenceNumber

This syntax can be used to get and set any field of an X12 message and it makes X12 parsing much more straightforward and self-documenting.

# The problem

X12 is a set of "standards" possessing all the elegance of an elephant designed by committee, and quite literally so, see www.x12.org. X12 defines rough syntax for specifying text messages, but each of more than 300 specifications defines its own message structure. While messages themselves are easy to parse with a simple tokenizer, their semantics is heavily dependent on the domain. For example, this is X12/997 message conveying "Functional Acknowledgment":

  ST*997*2878~AK1*HS*293328532~AK2*270*307272179~AK3*NM1*8*L1010_0*8~
  AK4*0:0*66*1~AK4*0:1*66*1~AK4*0:2*66*1~AK3*NM1*8*L1010_1*8~AK4*1:0*
  66*1~AK4*1:1*66*1~AK3*NM1*8*L1010_2*8~AK4*2:0*66*1~AK5*R*5~AK9*R*1*
  1*0~SE*8*2878~

I.e., X12 defines an alphabet and somewhat of a dictionary - not a grammar or semantics for each particular data interchange conversation. Because of many entrenched implementations and government mandates, the X12 is not going to die anytime soon, unfortunately.

The message above can be easily represented in Ruby as a nested array:

 m = [
      ['ST', '997', '2878'],
      ['AK1', 'HS', '293328532'],
      ['AK2', '270', '307272179'],
      ['AK3', 'NM1', '8', 'L1010_0', '8'],
      ['AK4', '0:0', '66', '1'],
      ['AK4', '0:1', '66', '1'],
      ['AK4', '0:2', '66', '1'],
      ['AK3', 'NM1', '8', 'L1010_1', '8'],
      ['AK4', '1:0', '66', '1'],
      ['AK4', '1:1', '66', '1'],
      ['AK3', 'NM1', '8', 'L1010_2', '8'],
      ['AK4', '2:0', '66', '1'],
      ['AK5', 'R', '5'],
      ['AK9', 'R', '1', '1', '0'],
      ['SE', '8', '2878'],
     ]

but it will not help any since, say, segment ‘AK4’ is ambiguously defined and its meaning not at all obvious until the message‘s structure is interpreted and correct ‘AK4’ segment is found.
# The solution
Message structure

Each participant in EDI has to know the structure of the data coming across the wire - X12 or no X12. The X12 structures are defined in so-called Implementation Guides - thick books with all the data pieces spelled out. There is no other choice, but to invent a computer-readable definition language that will codify these books. For familiarity sake we‘ll use XML. For example, the X12/997 message can be defined as

  <Definition>
    <Loop name="997">
      <Segment name="ST" min="1" max="1"/>
      <Segment name="AK1" min="1" max="1"/>
      <Loop name="L1000" max="999999" required="y">
        <Segment name="AK2" max="1" required="n"/>
        <Loop name="L1010" max="999999" required="n">
          <Segment name="AK3" max="1" required="n"/>
          <Segment name="AK4" max="99" required="n"/>
        </Loop>
        <Segment name="AK5" max="1" required="y"/>
      </Loop>
      <Segment name="AK9" max="1" required="y"/>
      <Segment name="SE"  max="1" required="y"/>
    </Loop>
  </Definition>

Namely, the 997 is a ‘loop’ containing segments ST (only one), AK1 (also only one), another loop L1000 (zero or many repeats), segments AK9 and SE. The loop L1000 can contain a segment AK2 (optional) and another loop L1010 (zero or many), and so on.

The segments’ structure can be further defined as, for example,

  <Segment name="AK2">
    <Field name="TransactionSetIdentifierCode" required="y" min="3" max="3" validation="T143"/>
    <Field name="TransactionSetControlNumber"  required="y" min="4" max="9"/>
  </Segment>

which defines a segment AK2 as having two fields: TransactionSetIdentifierCode and TransactionSetControlNumber. The field TransactionSetIdentifierCode is defined as having a type of string (default), being required, having length of minimum 3 and maximum 3 characters, and being validated against a table T143. The validation table is defined as

  <Table name="T143">
    <Entry name="100" value="Insurance Plan Description"/>
    <Entry name="101" value="Name and Address Lists"/>
    ...
    <Entry name="997" value="Functional Acknowledgment"/>
    <Entry name="998" value="Set Cancellation"/>
  </Table>

with entries having just names and values.

This message is fully flashed out in an example ‘misc/997.xml’ file, copied from the ASC X12N 276/277 (004010X093) "Health Care Claim Status Request and Response" National Electronic Data Interchange Transaction Set Implementation Guide.

Now expressions like

  message.L1000.L1010[1].AK4.DataElementReferenceNumber

start making sense of sorts, overall X12‘s idiocy notwithstanding - it‘s a field called ‘DataElementReferenceNumber’ of a first of possibly many segments ‘AK4’ found in the second repeat of the loop ‘L1010’ inside the enclosing loop ‘L1000’. The meaning of the value ‘66’ found in this field is still in the eye of the beholder, but, at least its location is clearly identified in the message.
# X12 Structure Definition Language

The syntax of the X12 structure definition language should be apparent from the ‘997.xml’ file enclosed with the package. A more detailed description follows in Appendix A.
# Parsing

Here is how to parse an X12/997 message (the source is in example/parse.rb):

  require 'x12'

  # Read message definition and create an actual parser
  # by compiling the XML file
  parser = X12::Parser.new('misc/997.xml')

  # Define a test message to parse
  m997='ST*997*2878~AK1*HS*293328532~AK2*270*307272179~'\
  'AK3*NM1*8*L1010_0*8~AK4*0:0*66*1~AK4*0:1*66*1~AK4*0:2*'\
  '66*1~AK3*NM1*8*L1010_1*8~AK4*1:0*66*1~AK4*1:1*66*1~AK3*'\
  'NM1*8*L1010_2*8~AK4*2:0*66*1~AK5*R*5~AK9*R*1*1*0~SE*8*2878~'

  # Parse the message
  r = parser.parse('997', m997)

  # Access components of the message as desired

  # Whole ST segment: -> ST*997*2878~
  puts r.ST

  # One filed, Group Control Number of AK1 -> 293328532
  puts r.AK1.GroupControlNumber

  # Individual loop, namely, third L1010 sub-loop of
  # L1000 loop: -> AK3*NM1*8*L1010_2*8~AK4*2:0*66*1~
  puts r.L1000.L1010[2]

  # First encounter of Data Element Reference Number of the
  # first L1010 sub-loop of L1000 loop -> 66
  puts r.L1000.L1010.AK4.DataElementReferenceNumber

  # Number of L1010 sub-loops in L1000 loop -> 3
  puts r.L1000.L1010.size

# Generating

Here is how to perform a reverse operation and generate a well-formed 997 message (the source is in example/factory.rb):

  require 'x12'

  # Read message definition and create an actual parser
  # by compiling .d12 file
  parser = X12::Parser.new('misc/997.xml')

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

# Major deficiencies

    Validation is not implemented.
    Field types and sizes are ignored.
    No access methods for composites’ fields.

# Acknowledgments

The authors of the project were inspired by the following works:

    * The Perl X12 parser by Prasad Poruporuthan, search.cpan.org/~prasad/X12-0.09/lib/X12/Parser.pm
    * The Ruby port of the above by Chris Parker, rubyforge.org/projects/x12-parser/
    * This project originated from App Design's X12 parser.  
	* Project was forked by Sean Walberg, creating version 1.2.0 in April 2012. 

# Appendix A. Structure definition language

The structure definition language uses XML to describe X12 message format. A message definition can be in a single file or in several. If the definition parser encounters an element (segment, composite, or table), which has not been previously defined, it tries to load the definition from the file with the same name and in the same directory. For example, if a loop mentions a segment named ‘ST’ and this segment is not defined, the parser will try to load and parse a file called ‘ST.xml’. This convention works for any name unless it conflicts with a Microsoft‘s device name, see Appendix B.

Each element in a structure definition (except ‘Definition’) must have an attribute called ‘name’. It is used to set/get respective content from Ruby. If an element‘s ‘name’ attribute cannot be a valid Ruby identifier (for example, ‘270’), the parser will prepend the name with ‘_’ (underscore). I.e., this expression is not valid:

  @r.FG[1].270[1].ST.TransactionSetIdentifierCode

but his one is

  @r.FG[1]._270[1].ST.TransactionSetIdentifierCode

Each XML file has to have a single root element, one of the following:
# Definition

The ‘Definition’ element can have nested loops, segments, composites, and tables. It is used to provide ‘artificial’ root element for XML document when several definitions are in one physical file. For example, this is `misc/997single.xml’ (edited for size):

  <Definition>
    <Segment name="ST">
      <Field name="TransactionSetIdentifierCode" min="3" max="3" validation="T143"/>
      <Field name="TransactionSetControlNumber"  min="4" max="9"/>
      <Field name="ImplementationConventionReference" required="y" min="1" max="35"/>
    </Segment>

    <Composite name="C030">
      <Field name="ElementPositionInSegment" type="long" required="n" min="1" max="2"/>
      <Field name="ComponentDataElementPositionInComposite" type="long" required="y" min="1" max="2"/>
      <Field name="RepeatingDataElementPosition" type="long" required="y" min="1" max="4"/>
    </Composite>

    <Segment name="AK1">
      <Field name="FunctionalIdentifierCode" min="2" max="2" validation="T479"/>
      <Field name="GroupControlNumber" type="long" min="1" max="9"/>
    </Segment>

    <Table name="T723">
      <Entry name="1" value="Mandatory data element missing"/>
      <Entry name="2" value="Conditional required data element missing."/>
      <!-- ... other entries -->
      <Entry name="13" value="Too Many Components"/>
    </Table>

    <!-- ... other segments or composites or tables -->

    <Loop name="997">
      <Segment name="ST" min="1" max="1"/>
      <Segment name="AK1" min="1" max="1"/>
      <Loop name="L1000" max="999999" required="y">
        <Segment name="AK2" max="1" required="n"/>
        <Loop name="L1010" max="999999" required="n">
          <Segment name="AK3" max="1" required="n"/>
          <Segment name="AK4" max="99" required="n"/>
        </Loop>
        <Segment name="AK5" max="1" required="y"/>
      </Loop>
      <Segment name="AK9" max="1" required="y"/>
      <Segment name="SE"  max="1" required="y"/>
    </Loop>

  </Definition>

This element does not have any attributes and cannot be addressed from Ruby‘s API.
Loop

The ‘Loop’ element is a main element to define either loops or whole messages. Loops can have nested segments and other loops.

Note, that a segment defined inside a loop takes precedence over previously defined segments. This is convenient if a special version of a segment is required. For example, this is a general definition of an ‘ST’ segment stored in a ‘ST.xml’ file:

  <Segment name="ST">
    <Field name="TransactionSetIdentifierCode" min="3" max="3" validation="T143"/>
    <Field name="TransactionSetControlNumber" min="4" max="9"/>
    <Field name="ImplementationConventionReference" required="y" min="1" max="35"/>
  </Segment>

If you want the X12 parser to look for a particular message type, say ‘997’, do this:

  <Loop name="997">
    <Segment name="ST"  max="1">
      <Field name="TransactionSetIdentifierCode" const="997"/>
      <Field name="TransactionSetControlNumber" min="4" max="9"/>
    </Segment>
    <Segment name="AK1" max="1"/>
    <!-- ... the rest of the 997 definition -->
  </Loop>

A loop can have the following attributes:

    min - minimal number of repeats allowed, default is 0.
    max - maximum number of repeats allowed, default is ‘inf’ (infinite).
    required - if the loop is required (boolean), default is false. The true value implies min="1".
    comment - ignored

# Segment

Segments can only have nested fields. Attributes are as follows:

    min - minimal number of repeats allowed, default is 0. Value min>0 implies required="y".
    max - maximum number of repeats allowed, default is ‘inf’ (infinite).
    required - if the segment is required (boolean), default is false. The true value implies min="1".
    comment - ignored

All attributed except ‘name’ are ignored in standalone definitions outside any loop.
Composite

Same as a segment.
# Table

Tables can only have entries defined as name-value pairs. Order is not important. Only required attribute is ‘name’.
Field

A field cannot have any nested elements, but its attributes are very important:

    min - minimal number of characters allowed, default is 0. Value min>0 DOES NOT imply required="y" - the field can be missing, but may require a minimum length if present.
    max - maximum number of characters allowed, default is ‘inf’ (infinite).
    required - if the field is required (boolean), default is false. The true value DOES NOT imply min="1".
    type - one of the ‘string’ (default), ‘integer’, ‘long’, or ‘double’. These abbreviations are also valid: ‘str’, ‘int’.
    const - forces the field to have this value, if present.
    validation - the name of a validation table, if any.
    comment - ignored

# Appendix B. Microsoft‘s device file names

Apparently, in Microsoft‘s operating systems one cannot create a file named like ‘device_name.whatever’, for example, ‘CON.xml’ is highly illegal. For such cases, the X12 parser creates an exception and expects ‘CON_.xml’ instead.

Here is the full device list according to Microsoft (see support.microsoft.com/kb/74496):

   Name    Function
   ----    --------
   CON     Keyboard and display
   PRN     System list device, usually a parallel port
   AUX     Auxiliary device, usually a serial port
   CLOCK$  System real-time clock
   NUL     Bit-bucket device
   A:-Z:   Drive letters
   COM1    First serial communications port
   LPT1    First parallel printer port
   LPT2    Second parallel printer port
   LPT3    Third parallel printer port
   COM2    Second serial communications port
   COM3    Third serial communications port
   COM4    Fourth serial communications port


# Change Log
12/2/12 - release 1.3.2
* Added the 835 transaction

12/1/12 - release 1.3.1
* Added the 837p transaction

11/23/12 - release 1.3.0
* Updated to work with Ruby version >= 1.9.1
* includes bundle gem_tasks
* In misc/T105.xml escaped ampersand in Dun & Bradstreet 
 
4/18/12 - Release 1.2.0
* Works with Ruby version >= 1.8.6
* All the gem info has been changed to use bundler
* Everything has been renamed to be lower case and work on case sensitive systems
* Stopped including REXML, which was causing problems with Rails 3 and mailer
* To use version 1.2.0, install with "$gem install sx12"

5/15/09 - Release 1.1.0
* Ported X12 definitions and definition parser from proprietary d12 language to XML.
* Added X12 definitions for 270 message and all its dependent segments and validation tables.

3/19/09 - Release 0.1.0
* Implemented field constants.
* Implemented separate definition files for segments and validation tables.

11/15/08 - Release 0.0.5, first public one
* Added comments.
* Added examples.
* Wrote README

4/10/08 - Release 0.0.1
* Internal release for testing
