# frozen_string_literal: true

require 'csv'
require 'json'
require_relative './trello/extract'
require_relative './trello/filter'
require_relative './trello/format'

class App
  def self.convert(year, data_file)
    CSV::Converters[:blank_to_nil] = lambda {|value| value && value.empty? ? nil : value}
    CSV.read(data_file, headers: true, header_converters: :symbol, converters: [:all, :blank_to_nil])
      .map { |row| row.to_h }
      .map { |hash| split_strings(hash, [:format]) }
  end

  def self.split_strings(hash, keys)
    keys.reduce(hash) do |memo, key|
      split_values = memo[key].split(',').map(&:strip)
      memo.merge({ **memo, key => split_values })
    end
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
