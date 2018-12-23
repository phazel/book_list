#!/usr/bin/env ruby

require 'json'

def format(book)
  <<~SUMMARY
  **#{book['name']}**
  *by #{book['desc']}*

  SUMMARY
end

hash = JSON.load File.read("./exported.json")

YEAR = '2018'

not_finished_label = hash['labels'].find{|label| label['name'] == 'Not Gonna Finish'}

read_list = hash['lists'].find{|list| list['name'] == "Read #{YEAR}" }
read_books = hash['cards'].select{|card| card['idList'] == read_list['id'] }

not_finished_books = []

output = read_books.map do |book|
  if book['idLabels'].include? not_finished_label['id']
    not_finished_books << book
    ""
  else
    format book
  end
end

output << "BOOKS I DIDN'T FINISH:\n\n"

output << not_finished_books.map do |book|
  format book
end

File.write "books_read_#{YEAR}.md", output.join
