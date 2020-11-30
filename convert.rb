#!/usr/bin/env ruby
require 'json'
require_relative './lib/find'
require_relative './lib/filter'
require_relative './lib/format'

YEAR = '2020'
READ_LIST = "Read #{YEAR}"
CURRENTLY_READING_LIST = "📖 Reading 📖"
DNF_LABEL = 'dnf'
FAVOURITE_LABEL = 'fav'

hash = JSON.load File.read("#{YEAR}/exported.json")

File.open("#{YEAR}/exported_pretty.json", "w") { |f| f.write JSON.pretty_generate hash }

read_list = Find.list(hash, READ_LIST)
currently_reading_list = Find.list(hash, CURRENTLY_READING_LIST)
favourite_label = Find.label(hash, FAVOURITE_LABEL)
dnf_label = Find.label(hash, DNF_LABEL)

books = Book.create_all(hash)
read = Filter.in_list(books, read_list)
data = {
  read: {
    favourites: Filter.with_label(read, favourite_label),
    regular: Filter.without_labels(read, [favourite_label, dnf_label]),
    total_finished: Filter.without_labels(read, [dnf_label]).size
  },
  dnf: Filter.with_label(read, dnf_label),
  currently_reading: Filter.in_list(books, currently_reading_list)
}

output = Format.header(YEAR, data[:read][:total_finished])
output += Format.section(data[:read][:favourites], :favourites)
output += Format.section(data[:read][:regular])
output += Format.section(data[:dnf], :dnf) if data[:dnf].any?
output += Format.section(data[:currently_reading], :currently_reading)

File.write "#{YEAR}/books_read_#{YEAR}.md", output.join
