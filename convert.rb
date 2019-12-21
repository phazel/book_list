#!/usr/bin/env ruby
require 'json'
require_relative './lib/find'
require_relative './lib/filter'
require_relative './lib/format'

YEAR = '2019'
READ_LIST = "Read #{YEAR}"
CURRENTLY_READING_LIST = "*** Reading ***"
NOT_FINISHING_LABEL = 'Not Gonna Finish'
FAVOURITE_LABEL = 'fav'

hash = JSON.load File.read("#{YEAR}/exported.json")

favourite = Find.label(hash, FAVOURITE_LABEL)
not_finishing = Find.label(hash, NOT_FINISHING_LABEL)

read_books = Find.books_in_list(hash, READ_LIST)
currently_reading = Find.books_in_list(hash, CURRENTLY_READING_LIST)

favourites = Filter.with_label(read_books, favourite)
regular = Filter.without_labels(read_books, [favourite, not_finishing])
not_finishing = Filter.with_label(read_books, not_finishing)

output = Format.header(YEAR, read_books.size)
output += Format.favourites(favourites)
output += Format.regular_read(regular)
output += Format.not_finishing(not_finishing) if not_finishing.any?
output += Format.currently_reading(currently_reading)

File.write "#{YEAR}/books_read_#{YEAR}.md", output.join
