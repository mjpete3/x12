# X12

This X12 library provides ability to create and parse EDI (Electronic Data Interchange) ANSI X12 messages.  The governing committee for EDI standards in the US is the ANSI ASC X12 committee. 

The transport mechanism for EDI tranmissions is not part of this library.

There are 2 major branches of this library:
- The master branch provides X12 support without the composite field support.  The master branch of this repository is compiled into a gem pd_x12.
- The master2 branch provides support including composites fields.  The xml definitions for the various segments which contain composite fields have bee updated with this version. The gem supporting composite fields is pd_x12_v2.

If your xml definitions and/or code is not setup to use the composite functions then you should install the pd_x12 gem.  Only use the pd_x12_v2 gem if you are prepared to use the composite functions.
  
Current version has been upgraded to run under ruby version >= 1.9.1 up to v2.1.2

Changes welcome, especially new document types or better tests.

# Installation

Add this line to your application's Gemfile:

    gem 'pd_x12_v2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pd_x12_v2

# Documentation
## Wiki Page: https://github.com/mjpete3/x12/wiki

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


## Major deficiencies

    Validation is not implemented.
    Field types are ignored.


# Change Log
11/10/14 - release 2.0.0
* Added ability to handle composite fields
*
* Revamped test cases

11/8/14 - release 1.5.0
* converted from ReXML to LibXML for speed improvement on XML parsing 



# Acknowledgments

The authors of the project were inspired by the following works:

    * The Perl X12 parser by Prasad Poruporuthan, search.cpan.org/~prasad/X12-0.09/lib/X12/Parser.pm
    * The Ruby port of the above by Chris Parker, rubyforge.org/projects/x12-parser/
    * This project originated from App Design's X12 parser.
    * Project was forked by Sean Walberg, creating version 1.2.0 in April 2012.
    * Project was forked by Marty Petersen in November 2012, creating pd_x12. 

# Change Log
4/16/15 - release 1.5.1
* Added inpsect method to loop class to resolve infinite loop due to changes with inspect and to_s methods in ruby 2.0.0
* Thank you to Wylan for troubleshooting and providing the fix 

11/8/14 - release 1.5.0
* converted from ReXML to LibXML for speed improvement on XML parsing 

9/14/13 - release 1.4.7
* Added 276 / 277 transaction messages 
* Fixed issue with 835.xml file

4/15/13 - release 1.4.5
* Factories now enforce minimum sizes - wbajzek contributed
* 270Interchange.xml updated ST segment's field list - wbajzek contributed
* Test updated for minimum size - wbajzek contributed

3/22/13 - releases 1.4.1 - 1.4.3
* Fix errors in the 835.xml file



