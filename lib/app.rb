# frozen_string_literal: true

require 'csv'
require 'json'
require_relative './convert'
require_relative './filter'
require_relative './format'
require_relative './models/hash'
include Convert
include Filter
include Format

class App
  def self.generate(data_file, output_file, year)
    books = get_books(data_file, year)
    output(books, output_file, year)
    summary(books)
  end

  def self.get_books(data_file, year)
    csv_to_books File.read(data_file), year
  end

  def self.output(books, output_file, year)
    done, current = filter_by_status(books).splat(:done, :current)
    dnf, finished = filter_by_dnf(done).splat(:dnf, :non_dnf)
    dups, non_dups, all = dedup(finished).splat(:dups, :non_dups, :all)

    fav, non_fav = filter_by_fav(non_dups).splat(:fav, :non_fav)
    sleep, non_sleep = filter_by_sleep(non_fav).splat(:sleep, :non_sleep)
    remaining = non_sleep

    output = post(
      year: year,
      total: finished.size,
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
end
