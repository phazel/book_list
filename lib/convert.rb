#!/usr/bin/env ruby
require 'json'

YEAR = '2019'
READ_LIST = "Read #{YEAR}"
CURRENTLY_READING_LIST = "*** Reading ***"
NOT_FINISHING_LABEL = 'Not Gonna Finish'
FAVOURITE_LABEL = 'fav'

def read_books(hash)
  read_list = hash['lists'].find{|list| list['name'] == READ_LIST }
  hash['cards'].select do |card|
    card['idList'] == read_list['id']
  end
end

def currently_reading_books(hash)
  currently_reading_list = hash['lists'].find{|list| list['name'] == CURRENTLY_READING_LIST }
  hash['cards'].select do |card|
    card['idList'] == currently_reading_list['id'] && !card['closed']
  end
end

def not_finishing_label(hash)
  hash['labels'].find{|label| label['name'] == NOT_FINISHING_LABEL}['id']
end

def favourite_label(hash)
  hash['labels'].find{|label| label['name'] == FAVOURITE_LABEL}['id']
end

def has_label(book, label)
  book['idLabels'].include? label
end

def with_label(books, label)
  books.select { |book| has_label(book, label) }
end

def without_labels(books, labels)
  books.reject { |book| labels.any? { |label| has_label(book, label) } }
end

def present(books)
  books.map do |book|
    <<~SUMMARY
    **#{book['name']}**
    *by #{book['desc']}*

    SUMMARY
  end
end

hash = JSON.load File.read("#{YEAR}/exported.json")

favourite = favourite_label(hash)
not_finishing = not_finishing_label(hash)
read_books = read_books(hash)

output = ["# Books Read In #{YEAR}\n"]
output << "`Total books read: #{read_books.size}`\n\n\n"

output << "## Favourites:\n\n"
favourites = with_label(read_books, favourite)
output << present(favourites)
output << "---\n\n"

regular_read_books = without_labels(read_books, [favourite, not_finishing])
output << present(regular_read_books)
output << "---\n\n"

not_finishing_books = with_label(read_books, not_finishing)
if not_finishing_books.any?
  output << "## Books I Decided Not To Finish:\n\n"
  output << present(not_finishing_books)
  output << "---\n\n"
end

output << "## Books I'm Currently Reading:\n\n"
output << present(currently_reading_books(hash))

File.write "#{YEAR}/books_read_#{YEAR}.md", output.join
