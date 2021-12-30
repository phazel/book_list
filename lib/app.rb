# frozen_string_literal: true

require 'csv'
require 'json'
require_relative './trello/extract'
require_relative './trello/filter'
require_relative './trello/format'
require_relative './notion/convert'
require_relative './notion/filter'
include Convert
include Filter

class App
  def self.generate(data_file, output_file)
    books = get_books(data_file)
    output(books, output_file)
    summary(books)
  end

  def self.get_books(data_file)
    csv_to_books File.read(data_file)
  end

  def self.output(books, output_file)
    done_books = filter_by_status(books)[:done]
    dups, non_dups = dedup(done_books).values_at(:dups, :non_dups)
    output = [
      "Books I Read More Than Once:\n",
      dups,
      "---\n\n",
      "Currently reading:\n",
      filter_by_status(books)[:current],
      "---\n\n",
      "Read this year:\n",
      non_dups,
    ]
    File.write output_file, output.join
  end

  def self.summary(books)
    done, current = filter_by_status(books).fetch_values(:done, :current)
    dups, non_dups, all = dedup(done).fetch_values(:dups, :non_dups, :all)
    audiobook, ebook, physical = filter_by_format(all).fetch_values(:audiobook, :ebook, :physical)
    {
      total: books.size,
      total_deduped: dedup(books)[:all].size,
      done: all.size,
      current: current.size,
      audiobook: audiobook.size,
      ebook: ebook.size,
      physical: physical.size,
      dups: dups.size,
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
    File.write "#{year}/trello_books_read_#{year}.md", output.join

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
