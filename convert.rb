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
AUDIOBOOK_LABEL = 'audiobook'

hash = JSON.load File.read("#{YEAR}/exported.json")

read_list = Find.list(hash, READ_LIST)
currently_reading_list = Find.list(hash, CURRENTLY_READING_LIST)
favourite_label = Find.label(hash, FAVOURITE_LABEL)
not_finishing_label = Find.label(hash, NOT_FINISHING_LABEL)
audiobook_label = Find.label(hash, AUDIOBOOK_LABEL)
books = Book.create_all(hash, audiobook_label)

read = Filter.in_list(books, read_list)
currently_reading = Filter.in_list(books, currently_reading_list)

favourites = Filter.with_label(read, favourite_label)
regular_read = Filter.without_labels(read, [favourite_label, not_finishing_label])
not_finishing = Filter.with_label(read, not_finishing_label)

output = Format.header(YEAR, read.size)
output += Format.section(favourites, :favourites)
output += Format.section(regular_read)
output += Format.section(not_finishing, :not_finishing) if not_finishing.any?
output += Format.section(currently_reading, :currently_reading)

File.write "#{YEAR}/books_read_#{YEAR}.md", output.join
