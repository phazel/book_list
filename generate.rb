#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require_relative './lib/extract'
require_relative './lib/filter'
require_relative './lib/format'

YEAR = '2020'

hash = Format.symbify JSON.parse File.read "#{YEAR}/exported.json"
File.open("#{YEAR}/exported_pretty.json", 'w') do |file|
  file.write JSON.pretty_generate hash
end

read, current = Extract.all_books(hash, YEAR).values_at(:read, :current)
dups, non_dups = Filter.duplicates(read).values_at(:dups, :non_dups)

sections = {
  count: Filter.without(read, [:dnf]).size,
  dups: dups,
  fav: Filter.with(non_dups, :fav),
  regular: Filter.without(non_dups, %i[fav dnf]),
  dnf: Filter.with(read, :dnf)
}

output = Format.result YEAR, sections, current

File.write "#{YEAR}/books_read_#{YEAR}.md", output.join
