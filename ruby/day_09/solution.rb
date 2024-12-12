# frozen_string_literal: true

# Entry struct for individual disk positions
Entry = Struct.new(:type, :len, :position, :original_position) do
  def file?
    type == :file
  end

  def empty?
    type == :empty
  end

  def to_s
    if empty?
      "." * len
    else
      original_position.to_s * len
    end
  end
end

class DiskStructure
  attr_reader :entries

  def initialize
    @entries = []
  end

  def add_entry(type:, len:, position:)
    entries << Entry.new(type, len, position, position)
  end

  def empty?
    entries.empty?
  end

  def display_line(e = entries)
    line = ""
    e.each do |entry|
      line += if entry.file?
          entry.original_position.to_s * entry.len
        else
          "." * entry.len
        end
    end
    puts line
  end

  def display
    display_line
    puts "\nTotal files: #{entries.count(&:file?)}"
    puts "Total empty spaces: #{entries.count(&:empty?)}"
    puts "Checksum: #{checksum}"
  end

  def checksum
    sum = 0
    i = 0
    entries.select(&:file?).each_with_index do |entry, _index|
      entry.len.times do |_j|
        sum += entry.original_position * i
        i += 1
      end
    end
    sum
  end

  def defragment_fast!
    new_entries = []
    original_index = entries.size
    entries.reverse.each_with_index do |entry, idx|
      original_index -= 1

      entries.each_with_index do |e, i|
        print "(" if idx == i
        print "[" if i == original_index
        print e
        print ")" if idx == i
        print "]" if i == original_index
      end
      puts

      if entry.file?
        puts "\tfile entry: #{entry}"
        0.upto(original_index) do |i|
          forward_entry = entries[i]
          puts "\tforward_entry: #{forward_entry}: #{forward_entry.empty?} #{forward_entry.len}"
          next if forward_entry.file?
          if forward_entry.len == entry.len
            entries[i] = entry
            entries[original_index] = Entry.new(:empty, entry.len, nil, nil)
            break
          elsif forward_entry.len > entry.len
            entries[original_index] = Entry.new(:empty, entry.len, nil, nil)
            entries[i] = entry
            puts "\t\t#{entries.map(&:to_s).join}"
            entries.insert(i + 1, Entry.new(:empty, forward_entry.len - entry.len, nil, nil))
            original_index += 1
            puts "\t\t#{entries.map(&:to_s).join}"
            puts entries.map(&:to_s).join
          end
        end
      end
    end

    self
  end

  def defragment!
    new_entries = []
    forward_pointer = 0
    backward_pointer = entries.size - 1
    while forward_pointer <= backward_pointer
      if forward_pointer == backward_pointer
        new_entries << entries[forward_pointer]
        break
      end

      forward_entry = entries[forward_pointer]
      backward_entry = entries[backward_pointer]

      if forward_entry.file?
        new_entries << forward_entry
        forward_pointer += 1
      elsif backward_entry.file? && backward_entry.len.positive?
        if forward_entry.len > backward_entry.len
          new_entries << backward_entry
          forward_entry.len -= backward_entry.len
          backward_pointer -= 1
        else
          diff = backward_entry.len - forward_entry.len
          new_entries << Entry.new(
            :file,
            forward_entry.len,
            forward_entry.original_position,
            backward_entry.original_position
          )
          backward_entry.len = diff
          forward_pointer += 1
        end
      else
        backward_pointer -= 1
      end
    end
    @entries = new_entries
    self
  end
end

class Solution
  attr_reader :diskmap

  def initialize(file)
    raise ArgumentError, "File path cannot be nil" unless file

    @file = file
    load_diskmap
  end

  def solution_1
    return 0 if diskmap.nil? || diskmap.empty?

    disk_structure = DiskStructure.new
    diskmap.chars.each_with_index do |char, index|
      disk_structure.add_entry(
        type: index.odd? ? :empty : :file,
        len: char.to_i,
        position: index.odd? ? nil : index / 2,
      )
    end

    disk_structure.display

    new_disk_structure = disk_structure.defragment!

    new_disk_structure.display

    new_disk_structure.checksum
  end

  def solution_2
    return 0 if diskmap.nil? || diskmap.empty?

    disk_structure = DiskStructure.new
    diskmap.chars.each_with_index do |char, index|
      disk_structure.add_entry(
        type: index.odd? ? :empty : :file,
        len: char.to_i,
        position: index.odd? ? nil : index / 2,
      )
    end

    disk_structure.display

    new_disk_structure = disk_structure.defragment_fast!

    new_disk_structure.display

    new_disk_structure.checksum
  end

  private

  def load_diskmap
    @diskmap = File.read(@file).strip
  rescue Errno::ENOENT
    raise "Could not read disk map file: #{@file}"
  end
end
