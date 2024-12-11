# Entry struct for individual disk positions
Entry = Struct.new(:type, :length, :position, :original_position) do
  def file?
    type == :file
  end

  def empty?
    type == :empty
  end
end

class DiskStructure
  attr_reader :entries

  def initialize
    @entries = []
  end

  def add_entry(type:, length:, position:)
    e = Entry.new(type, length, position, position)  # Store original position
    entries << e
    e
  end

  def empty?
    entries.empty?
  end

  def display_line
    line = ""
    entries.each do |entry|
      if entry.file?
        line += entry.original_position.to_s * entry.length
      else
        line += "." * entry.length
      end
    end
    puts line
  end

  def display
    display_line  # Add single line display
    puts "\nTotal files: #{entries.count(&:file?)}"
    puts "Total empty spaces: #{entries.count(&:empty?)}"
    puts "Checksum: #{checksum}"
  end

  def checksum
    sum = 0
    i = 0 
    entries.select(&:file?).each_with_index do |entry, index|
      entry.length.times do |j|
        sum += entry.original_position * i
        i += 1
      end
    end
    sum
  end

  def defragment
    new_structure = DiskStructure.new
    file_entries = entries.select(&:file?)
    empty_entries = entries.select(&:empty?)
    current_position = 0

    d_entries = entries.dup

    file_to_move = nil
    # Process files sequentially
    entries.each do |entry|
      if entry.file?
        entry_to_insert = entry.dup
        new_structure.entries << entry_to_insert
      else
        space_left = entry.length
        while space_left > 0
          if file_to_move.nil?
            until (file_to_move = entries.pop).file?
            end
          end
          if space_left >= file_to_move.length
            entry_to_insert = file_to_move.dup
            space_left -= file_to_move.length
          else
            entry_to_insert = Entry.new(
              :file,
              space_left,
              current_position,
              file_to_move.original_position
            )
            remaining_length = file_to_move.length - space_left
            space_left = 0
            entries.push(
              Entry.new(
                :file,
                remaining_length,
                file_to_move.original_position,
                file_to_move.original_position
              )
            )
          end

          new_structure.entries << entry_to_insert
          file_to_move = nil
        end
      end

      current_position += entry.length
    end

    # Add empty spaces
    empty_entries.each do |entry|
      new_structure.entries << Entry.new(
        entry.type,
        entry.length,
        current_position,
        entry.original_position
      )
      current_position += entry.length
    end

    new_structure
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
      e = disk_structure.add_entry(
        type: index.odd? ? :empty : :file,
        length: char.to_i,
        position: index.odd? ? nil : index / 2,
      )
    end

    disk_structure.display
    puts "Checksum: #{disk_structure.checksum}"

    new_disk_structure = disk_structure.defragment
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
