#!/usr/bin/env ruby
require 'json'

YEAR = '2018'

def read_books(hash)
  read_list = hash['lists'].find{|list| list['name'] == "Read #{YEAR}" }
  hash['cards'].select{|card| card['idList'] == read_list['id'] }
end

def currently_reading_books(hash)
  currently_reading_list = hash['lists'].find{|list| list['name'] == "*** Reading ***" }
  hash['cards'].select do |card|
    card['idList'] == currently_reading_list['id'] && !card['closed']
  end
end

def format(book)
  <<~SUMMARY
  **#{book['name']}**
  *by #{book['desc']}*

  SUMMARY
end

hash = JSON.load File.read("#{YEAR}/exported.json")

not_finishing_label = hash['labels'].find{|label| label['name'] == 'Not Gonna Finish'}
not_finishing_books = []

output = ["# Books Read In #{YEAR}\n"]
output << "`Total books: #{read_books(hash).size}`\n\n\n"
output << read_books(hash).map do |book|
  not_finishing = book['idLabels'].include? not_finishing_label['id']
  not_finishing_books << book if not_finishing
  not_finishing ? "" : format(book)
end

output << "## Books I Decided Not To Finish:\n\n"
output << not_finishing_books.map{ |book| format(book) }

output << "## Books I'm Currently Reading:\n\n"
output << currently_reading_books(hash).map{ |book| format(book) }

File.write "#{YEAR}/books_read_#{YEAR}.md", output.join
