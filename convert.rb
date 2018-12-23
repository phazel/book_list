#!/usr/bin/env ruby

require 'json'

YEAR = '2018'

hash = JSON.load File.read("#{YEAR}/exported.json")

read_list = hash['lists'].find{|list| list['name'] == "Read #{YEAR}" }
read_books = hash['cards'].select{|card| card['idList'] == read_list['id'] }

not_finished_label = hash['labels'].find{|label| label['name'] == 'Not Gonna Finish'}
not_finished_books = []

output = read_books.map do |book|
  not_finished = book['idLabels'].include? not_finished_label['id']
  not_finished_books << book if not_finished
  not_finished ? "" : format(book)
end

output << "BOOKS I DIDN'T FINISH:\n\n"
output << not_finished_books.map{ |book| format(book) }

File.write "#{YEAR}/books_read_#{YEAR}.md", output.join

def format(book)
  <<~SUMMARY
  **#{book['name']}**
  *by #{book['desc']}*

  SUMMARY
end
