#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './lib/app'

YEAR = '2021'
summary = App.generate YEAR

puts <<~SUMMARY
**********************************************
You read #{summary[:count]} books in #{YEAR}

- #{summary[:fav]} were favourites
- You read #{summary[:dups]} more than once
- #{summary[:nat]} were with Natalie
- #{summary[:sleep]} helped you get to sleep
- #{summary[:audiobook]} audiobooks, #{summary[:ebook]} ebooks, #{summary[:physical]} physical books
- You declined to finish #{summary[:dnf]}
- You're currently reading #{summary[:current]} books
**********************************************
SUMMARY
