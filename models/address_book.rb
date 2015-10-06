require_relative "entry.rb"
require "csv"

class AddressBook
  attr_accessor :entries

  def initialize
    @entries = []
  end

  def add_entry(name, phone, email)
    index = 0

    @entries.each do |entry|
      break if name < entry.name
      index += 1
    end
    @entries.insert(index, Entry.new(name, phone, email))
  end

  def remove_entry(name, phone, email)
    @entries.each do |entry|
      if name == entry.name && phone == entry.phone_number && email == entry.email
        @entries.delete(entry)
        break
      end
    end
  end

  def import_from_csv(file_name)
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)

    csv.each do |row|
      row_hash = row.to_hash
      add_entry(row_hash["name"], row_hash["phone_number"], row_hash["email"])
    end
  end

  def binary_search(name, lower, upper)
    mid = (upper + lower) / 2
    return nil if lower > upper
    return entries[mid] if entries[mid].name == name

    if entries[mid].name > name
      binary_search(name, lower, (mid - 1))
    elsif entries[mid].name < name
      binary_search(name, (mid + 1), upper)
    end
  end

  def iterative_search(name)
    @entries.each do |entry|
      return entry if entry.name == name
    end
    nil
  end
end
