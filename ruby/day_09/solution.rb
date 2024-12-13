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
    0.upto(e.size - 1).map { |i| i.to_s }.join("\t") + "\n" +
    e.map(&:to_s).join("\t")
  end

  def display
    puts display_line
    print "\nTotal files: #{entries.count(&:file?)}\t"
    print "Total empty spaces: #{entries.count(&:empty?)}"
    puts "Checksum: #{checksum}"
  end

  def checksum
    sum = 0
    i = 0
    entries.each_with_index do |entry, _index|
      entry.len.times do |_j|
        if entry.file?
          sum += entry.original_position * i
        end
        i += 1
      end
    end
    sum
  end

  def defragment_fast!
    files_to_move = entries.dup.reverse
    files_to_move.each do |file|
      next if file.empty?
      original_index = entries.index(file)
      (0..original_index).each do |i|
        destination = entries[i]
        if destination.nil?
          exit(1)
        end
        next if destination.file?
        if destination.len == file.len
          entries[i] = file
          entries[original_index] = Entry.new(:empty, file.len, nil, nil)
          break
        end
        if destination.len > file.len
          entries[i] = file
          entries[original_index] = Entry.new(:empty, file.len, nil, nil)
          entries.insert(i + 1, Entry.new(:empty, destination.len - file.len, nil, nil))
          break
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

    new_disk_structure = disk_structure.defragment!
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

    new_disk_structure = disk_structure.defragment_fast!
    new_disk_structure.checksum
  end

  private

  def load_diskmap
    @diskmap = File.read(@file).strip
  rescue Errno::ENOENT
    raise "Could not read disk map file: #{@file}"
  end
end
