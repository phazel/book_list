#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require_relative './lib/extract'
require_relative './lib/filter'
require_relative './lib/format'

YEAR = '2020'

hash = Format.symbify JSON.parse File.read "#{YEAR}/exported.json"
File.open("#{YEAR}/exported_pretty.json", 'w') do |file|
  file.write JSON.pretty_generate hash
end

lists = Extract.lists(hash, YEAR)
books = Extract.all_books(hash)

read = Filter.in_list(books, lists[:read])
current = Filter.in_list(books, lists[:current])
dups, non_dups = Filter.duplicates(read).values_at(:dups, :non_dups)

sections = {
  count: Filter.books_without(read, [:dnf]).size,
  dups: dups,
  fav: Filter.books_with(non_dups, :fav),
  regular: Filter.books_without(non_dups, [:fav, :dnf]),
  dnf: Filter.books_with(read, :dnf)
}

output = Format.result YEAR, sections, current

File.write "#{YEAR}/books_read_#{YEAR}.md", output.join
