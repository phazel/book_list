# frozen_string_literal: true

require 'csv'
require 'json'
require_relative './trello/extract'
require_relative './trello/filter'
require_relative './trello/format'
require_relative './notion/convert'
require_relative './notion/filter'
require_relative './notion/format'
require_relative './notion/models/hash'
include Convert
include Filter
include Format

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
    done, current = filter_by_status(books).splat(:done, :current)
    dups, non_dups, all = dedup(done).splat(:dups, :non_dups, :all)
    fav, non_fav = filter_by_fav(non_dups).splat(:fav, :non_fav)
    sleep, non_sleep = filter_by_sleep(non_fav).splat(:sleep, :non_sleep)
    dnf, remaining = filter_by_dnf(non_sleep).splat(:dnf, :non_dnf)

    output = post(
      total: all.size,
      dups: dups,
      sleep: sleep,
      fav: fav,
      remaining: remaining,
      dnf: dnf,
      current: current,
    )
    File.write output_file, output
  end

  def self.summary(books)
    done, current = filter_by_status(books).splat(:done, :current)
    dups, all = dedup(done).splat(:dups, :all)
    dnf, finished = filter_by_dnf(all).splat(:dnf, :non_dnf)
    fav = filter_by_fav(finished)[:fav]
    nat = filter_by_nat(finished)[:nat]
    sleep = filter_by_sleep(finished)[:sleep]
    reread = filter_by_reread(finished)[:reread]
    audiobook, ebook, physical, read_aloud = filter_by_format(finished).splat(:audiobook, :ebook, :physical, :read_aloud)
    {
      total: books.size,
      total_deduped: dedup(books)[:all].size,
      done: all.size,
      current: current.size,
      audiobook: audiobook.size,
      ebook: ebook.size,
      physical: physical.size,
      read_aloud: read_aloud.size,
      dups: dups.size,
      fav: fav.size,
      nat: nat.size,
      sleep: sleep.size,
      reread: reread.size,
      dnf: dnf.size,
    }
  end

  def self.generate_from_trello(year)
    hash = TrelloFormat.strip TrelloFormat.symbify JSON.parse File.read "#{year}/exported.json"
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

    output = TrelloFormat.result year, sections, current
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
