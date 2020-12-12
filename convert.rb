#!/usr/bin/env ruby
require 'json'
require_relative './lib/find'
require_relative './lib/filter'
require_relative './lib/format'

YEAR = '2020'

hash = Format.symbify JSON.parse File.read "#{YEAR}/exported.json"
File.open("#{YEAR}/exported_pretty.json", "w") do |file|
  file.write JSON.pretty_generate hash
end

lists = Find.lists(hash, YEAR)
labels = Find.labels(hash)
books = Book.create_all(hash)
all_read = Filter.in_list(books, lists[:read])

read = {
  count: Filter.without_labels(all_read, [labels[:dnf]]).size,
  dups: Filter.duplicates(all_read),
  fav: Filter.with_label(all_read, labels[:fav]),
  regular: Filter.without_labels(all_read, [labels[:fav], labels[:dnf]]),
  dnf: Filter.with_label(all_read, labels[:dnf]),
}
current = Filter.in_list(books, lists[:current])

output = Format.result YEAR, read, current

File.write "#{YEAR}/books_read_#{YEAR}.md", output.join
