#!/usr/bin/env ruby
require 'json'

YEAR = '2018'

def not_finishing(hash)
  hash['labels'].find{|label| label['name'] == 'Not Gonna Finish'}['id']
end

def read_books(hash)
  read_list = hash['lists'].find{|list| list['name'] == "Read #{YEAR}" }
  hash['cards'].select do|card|
    card['idList'] == read_list['id'] &&
    !card['idLabels'].include?(not_finishing(hash))
  end
end

def not_finishing_books(hash)
  hash['cards'].select { |card| card['idLabels'].include? not_finishing(hash) }
end

def currently_reading_books(hash)
  currently_reading_list = hash['lists'].find{|list| list['name'] == "*** Reading ***" }
  hash['cards'].select do |card|
    card['idList'] == currently_reading_list['id'] && !card['closed']
  end
end

def format(books)
  books.map do |book|
    <<~SUMMARY
    **#{book['name']}**
    *by #{book['desc']}*

    SUMMARY
  end
end

hash = JSON.load File.read("#{YEAR}/exported.json")

output = ["# Books Read In #{YEAR}\n"]
output << "`Total books read: #{read_books(hash).size}`\n\n\n"
output << format(read_books(hash))

output << "## Books I Decided Not To Finish:\n\n"
output << format(not_finishing_books(hash))

output << "## Books I'm Currently Reading:\n\n"
output << format(currently_reading_books(hash))

File.write "#{YEAR}/books_read_#{YEAR}.md", output.join
