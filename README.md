# X12

This is a fork of the project from http://www.appdesign.com/x12parser/, with the following changes:

Version: 1.3.0
* Updated to work with Ruby version >= 1.9.1
* includes bundle gem_tasks
* In misc/T105.xml escaped apersand in Dun & Bradstreet   

 
Version: 1.2.0
* Works with Ruby version >= 1.8.6
* All the gem info has been changed to use bundler
* Everything has been renamed to be lower case and work on case sensitive systems
* Stopped including REXML, which was causing problems with Rails 3 and mailer

Changes welcome, especially new document types or better tests.

## Installation

Add this line to your application's Gemfile:

    gem 'x12'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install x12

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
