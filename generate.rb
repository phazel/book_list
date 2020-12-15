#!/usr/bin/env ruby
require 'json'
require_relative './lib/extract'
require_relative './lib/filter'
require_relative './lib/format'

YEAR = '2020'

hash = Format.symbify JSON.parse File.read "#{YEAR}/exported.json"
File.open("#{YEAR}/exported_pretty.json", "w") do |file|
  file.write JSON.pretty_generate hash
end

lists = Extract.lists(hash, YEAR)
labels = Extract.labels(hash)
books = Extract.all_books(hash)

read = Filter.in_list(books, lists[:read])
current = Filter.in_list(books, lists[:current])

sections = {
  count: Filter.without_labels(read, [labels[:dnf]]).size,
  dups: Filter.duplicates(read),
  fav: Filter.with_label(read, labels[:fav]),
  regular: Filter.without_labels(read, [labels[:fav], labels[:dnf]]),
  dnf: Filter.with_label(read, labels[:dnf]),
}

output = Format.result YEAR, sections, current

File.write "#{YEAR}/books_read_#{YEAR}.md", output.join
