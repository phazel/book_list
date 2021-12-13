# frozen_string_literal: true

require 'csv'
require 'json'
require_relative './trello/extract'
require_relative './trello/filter'
require_relative './trello/format'
require_relative './notion/convert'
include Convert

class App
  def self.generate(year, data_file)
    csv_to_hash File.read(data_file)
  end

  def self.generate_from_trello(year)
    hash = Format.strip Format.symbify JSON.parse File.read "#{year}/exported.json"
    File.open("#{year}/exported_pretty.json", 'w') do |file|
      file.write JSON.pretty_generate hash
    end

    all_books = Extract.all_books(hash, year)
    read, current = Filter.by_list(all_books).values_at(:read, :current)
    dups, non_dups = Filter.duplicates(read).values_at(:dups, :non_dups)

    sections = {
      count: Filter.without(read, [:dnf]).size,
      dups: dups,
      fav: Filter.with(non_dups, :fav),
      regular: Filter.without(non_dups, %i[fav dnf]),
      dnf: Filter.with(read, :dnf)
    }

    output = Format.result year, sections, current
    File.write "#{year}/books_read_#{year}.md", output.join

    {
      count: sections[:count],
      fav: sections[:fav].size,
      dups: dups.size,
      nat: Filter.with(read, :nat).size,
      sleep: Filter.with(read, :sleep).size,
      audiobook: Filter.with(read, :audiobook).size,
      ebook: Filter.with(read, :ebook).size,
      physical: Filter.without(read, [:audiobook, :ebook]).size,
      dnf: sections[:dnf].size,
      current: current.size,
    }
  end
end
