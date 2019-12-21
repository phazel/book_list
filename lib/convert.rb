#!/usr/bin/env ruby
require 'json'
require_relative './books'
require_relative './labels'

YEAR = '2019'
READ_LIST = "Read #{YEAR}"
CURRENTLY_READING_LIST = "*** Reading ***"
NOT_FINISHING_LABEL = 'Not Gonna Finish'
FAVOURITE_LABEL = 'fav'

hash = JSON.load File.read("#{YEAR}/exported.json")

favourite = Labels.find(hash, FAVOURITE_LABEL)
not_finishing = Labels.find(hash, NOT_FINISHING_LABEL)
read_books = Books.find(hash, READ_LIST)

output = ["# Books Read In #{YEAR}\n"]
output << "`Total books read: #{read_books.size}`\n\n\n"

output << "## Favourites:\n\n"
favourites = Labels.with_label(read_books, favourite)
output << Books.present(favourites)
output << "---\n\n"

regular_read_books = Labels.without_labels(read_books, [favourite, not_finishing])
output << Books.present(regular_read_books)
output << "---\n\n"

not_finishing_books = Labels.with_label(read_books, not_finishing)
if not_finishing_books.any?
  output << "## Books I Decided Not To Finish:\n\n"
  output << Books.present(not_finishing_books)
  output << "---\n\n"
end

output << "## Books I'm Currently Reading:\n\n"
output << Books.present(Books.find(hash, CURRENTLY_READING_LIST))

File.write "#{YEAR}/books_read_#{YEAR}.md", output.join