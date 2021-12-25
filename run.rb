#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './lib/app'

YEAR = '2021'
summary = App.generate YEAR, "#{YEAR}/notion.csv"

puts <<~SUMMARY
**********************************************
Data contained #{summary[:total]} books

- You're currently reading #{summary[:current]} books
- You read #{summary[:done]}, with status 'Read 2021'
**********************************************
SUMMARY
