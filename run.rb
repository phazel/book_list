#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './lib/app'

YEAR = '2021'
summary = App.generate "#{YEAR}/notion.csv", "#{YEAR}/books_read_#{YEAR}.md"

puts <<~SUMMARY
**********************************************
Data contained #{summary[:total]} books

- You're currently reading #{summary[:current]} books
- You read #{summary[:done]}, with status 'Read 2021'
- You favourited #{summary[:fav]} of the total books
- You read #{summary[:nat]} of the total books with Nat
- You read #{summary[:sleep]} of the total books to go to sleep
- You'd already read #{summary[:reread]} of the total books
- You DNFed #{summary[:dnf]} of the total books
- #{summary[:audiobook]} of the total books are audiobooks
- #{summary[:ebook]} of the total books are ebooks
- #{summary[:physical]} of the total books are physical books
- You read aloud #{summary[:read_aloud]} of the total books
**********************************************
SUMMARY
