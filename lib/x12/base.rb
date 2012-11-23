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
module X12

  # $Id: Base.rb 70 2009-03-26 19:25:39Z ikk $
  #
  # Base class for Segment, Composite, and Loop. Contains setable
  # segment_separator, field_separator, and composite_separator fields.

  class Base

    attr_reader :name, :repeats
    attr_reader :segment_separator, :field_separator, :composite_separator, :next_repeat, :parsed_str, :nodes
    attr_writer :segment_separator, :field_separator, :composite_separator, :next_repeat, :parsed_str, :nodes

    # Creates a new base element with a given name, array of sub-elements, and array of repeats if any.
    def initialize(name, arr, repeats = nil)
      @nodes = arr
      @name = name
      @repeats = repeats
      @next_repeat = nil        # Next repeat of the same element, if any
      @parsed_str = nil

      @segment_separator   = '~'
      @field_separator     = '*'
      @composite_separator = ':'

      #puts "Created #{name} #{object_id} #{self.class}  "
    end

    # Formats a printable string containing the base element's content
    def inspect
      "#{self.class.to_s.sub(/^.*::/, '')} (#{name}) #{repeats} #{super.inspect[1..-2]} =<#{parsed_str}, #{next_repeat.inspect}> ".gsub(/\\*\"/, '"')
    end

    # Prints a tree-like representation of the element
    def show(ind = '')
      count = 0
      self.to_a.each{|i|
        #puts "#{ind}#{i.name} #{i.object_id} #{i.super.object_id} [#{count}]: #{i.parsed_str} #{i.super.class}"
        puts "#{ind}#{i.name} [#{count}]: #{i.to_s.sub(/^(.{30})(.*?)(.{30})$/, '\1...\3')}"
        # Force parsing a segment
        if i.kind_of?(X12::Segment) && i.nodes[0]
          i.find_field(i.nodes[0].name)
        end
        i.nodes.each{|j|
          case 
          when j.kind_of?(X12::Base)  then j.show(ind+'  ')
          when j.kind_of?(X12::Field) then puts "#{ind+'  '}#{j.name} -> '#{j.to_s}'"
          end
        } 
        count += 1
      }
    end

    # Try to parse the current element one more time if required. Returns the rest of the string
    # or the same string if no more repeats are found or required.
    def do_repeats(s)
      if self.repeats.end > 1
        possible_repeat = self.dup
        p_s = possible_repeat.parse(s)
        if p_s
          s = p_s
          self.next_repeat = possible_repeat
        end # if parsed
      end # more repeats
      s
    end # do_repeats

    # Empty out the current element
    def set_empty!
      @next_repeat = nil
      @parsed_str = nil
      self
    end

    # Make a deep copy of the element
    def dup
      n = clone
      n.set_empty!
      n.nodes = n.nodes.dup
      n.nodes.each_index{|i|
        n.nodes[i] = n.nodes[i].dup
        n.nodes[i].set_empty!
      }
      #puts "Duped #{self.class} #{self.name} #{self.object_id} #{super.object_id} -> #{n.name} #{n.super.object_id} #{n.object_id} "
      n
    end # dup

    # Recursively find a sub-element, which also has to be of type Base.
    def find(e)
      #puts "Finding [#{e}] in #{self.class} #{name}"
      case self
        when X12::Loop
        # Breadth first
        res = nodes.find{|i| e==i.name }
        return res if res
        # Depth now
        nodes.each{|i| 
          res = i.find(e) if i.kind_of?(X12::Loop)
          return res unless res.nil? or EMPTY==res # otherwise keep looping
        }
        when X12::Segment
        return find_field(e).to_s
      end # case
      return EMPTY
    end
    
    # Present self and all repeats as an array with self being #0
    def to_a
      res = [self]
      nr = self.next_repeat
      while nr do
        res << nr
        nr = nr.next_repeat
      end
      res
    end

    # Returns a parsed string representation of the element
    def to_s
      @parsed_str || ''
    end

    # The main method implementing Ruby-like access methods for nested elements
    def method_missing(meth, *args, &block)
      str = meth.id2name
      str = str[1..str.length] if str =~ /^_\d+$/ # to avoid pure number names like 270, 997, etc.
      #puts "Missing #{str}"
      if str =~ /=$/
        # Assignment
        str.chop!
        #puts str
        case self
        when X12::Segment
          res = find_field(str)
          throw Exception.new("No field '#{str}' in segment '#{self.name}'") if EMPTY == res
          res.content = args[0].to_s
          #puts res.inspect
        else
          throw Exception.new("Illegal assignment to #{meth} of #{self.class}")
        end # case
      else
        # Retrieval
        res = find(str)
        yield res if block_given?
        res
      end # if assignment
    end
    
    # The main method implementing Ruby-like access methods for repeating elements
    def [](*args)
      #puts "squares #{args.inspect}"
      return self.to_a[args[0]] || EMPTY
    end

    # Yields to accompanying block passing self as a parameter.
    def with(&block)
      if block_given?
        yield self 
      else
        throw Exception.new("Method 'with' requires a block.")
      end
    end
    
    # Returns number of repeats
    def size
      return self.to_a.size
    end

    # Check if any of the fields has been set yet
    def has_content?
      self.nodes.find{|i| i.has_content?}
    end

    # Adds a repeat to a segment or loop. Returns a new segment/loop or self if empty.
    def repeat
      res = if self.has_content? # Do not repeat an empty segment
              last_repeat = self.to_a[-1]
              last_repeat.next_repeat = last_repeat.dup
            else
              self
            end
      yield res if block_given?
      res
    end

  end # Base
end
