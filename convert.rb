#!/usr/bin/env ruby
require 'json'
require_relative './lib/find'
require_relative './lib/filter'
require_relative './lib/format'

YEAR = '2020'

hash = JSON.load File.read("#{YEAR}/exported.json")

File.open("#{YEAR}/exported_pretty.json", "w") { |f| f.write JSON.pretty_generate hash }

lists = Find.lists(hash, YEAR)
labels = Find.labels(hash)

books = Book.create_all(hash)
all_read = Filter.in_list(books, lists['read'])
read = {
  favourites: Filter.with_label(all_read, labels['fav']),
  regular: Filter.without_labels(all_read, [labels['fav'], labels['dnf']]),
  total_finished: Filter.without_labels(all_read, [labels['dnf']]).size
}
dnf = Filter.with_label(all_read, labels['dnf'])
currently_reading = Filter.in_list(books, lists['current'])

output = Format.header(YEAR, read[:total_finished])
output += Format.section(read[:favourites], :favourites)
output += Format.section(read[:regular])
output += Format.section(dnf, :dnf) if dnf.any?
output += Format.section(currently_reading, :currently_reading)

File.write "#{YEAR}/books_read_#{YEAR}.md", output.join
