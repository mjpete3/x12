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

    $ gem install PD_x12

## Documentation
### Wiki Page: https://github.com/mjpete3/x12/wiki

## Major deficiencies

    Validation is not implemented.
    Field types and sizes are ignored.
    No access methods for composites’ fields.

# Acknowledgments

The authors of the project were inspired by the following works:

    * The Perl X12 parser by Prasad Poruporuthan, search.cpan.org/~prasad/X12-0.09/lib/X12/Parser.pm
    * The Ruby port of the above by Chris Parker, rubyforge.org/projects/x12-parser/
    * This project originated from App Design's X12 parser.  
	* Project was forked by Sean Walberg, creating version 1.2.0 in April 2012. 


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
