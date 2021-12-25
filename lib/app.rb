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
    books = csv_to_books File.read(data_file)
    {
      total: books.size
    }
  end

  def self.generate_from_trello(year)
    hash = Format.strip Format.symbify JSON.parse File.read "#{year}/exported.json"
    File.open("#{year}/exported_pretty.json", 'w') do |file|
      file.write JSON.pretty_generate hash
    end

    all_books = Extract.all_books(hash, year)
    read, current = TrelloFilter.by_list(all_books).values_at(:read, :current)
    dups, non_dups = TrelloFilter.duplicates(read).values_at(:dups, :non_dups)

    sections = {
      count: TrelloFilter.without(read, [:dnf]).size,
      dups: dups,
      fav: TrelloFilter.with(non_dups, :fav),
      regular: TrelloFilter.without(non_dups, %i[fav dnf]),
      dnf: TrelloFilter.with(read, :dnf)
    }

    output = Format.result year, sections, current
    File.write "#{year}/books_read_#{year}.md", output.join

    {
      count: sections[:count],
      fav: sections[:fav].size,
      dups: dups.size,
      nat: TrelloFilter.with(read, :nat).size,
      sleep: TrelloFilter.with(read, :sleep).size,
      audiobook: TrelloFilter.with(read, :audiobook).size,
      ebook: TrelloFilter.with(read, :ebook).size,
      physical: TrelloFilter.without(read, [:audiobook, :ebook]).size,
      dnf: sections[:dnf].size,
      current: current.size,
    }
  end
end
