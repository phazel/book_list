# frozen_string_literal: true

require 'csv'
require_relative '../notion/models/book'
require_relative './helpers'
include Helpers::Convert

module Convert
  def split_strings(hash, keys)
    keys.reduce(hash) do |memo, key|
      return memo unless memo[key]
      split_values = memo[key].split(',').map(&:strip)
      memo.merge({ **memo, key => split_values })
    end
  end

  def split_strings_sym(hash, keys)
    keys.reduce(hash) do |memo, key|
      return memo unless memo[key]
      split_values = memo[key].split(',').map(&:strip).map(&:to_sym)
      memo.merge({ **memo, key => split_values })
    end
  end

  def nil_to_empty(hash, key)
    hash[key].nil? ? hash.merge({ key => [] }) : hash
  end

  def fav_bool(hash)
    hash.merge({ fav: hash[:fav].to_s.downcase == 'yes' })
  end

  def csv_to_hashes(csv)
    csv_converters
    CSV.new(csv, headers: true, header_converters: :all, converters: :mine)
      .map { |row| row.to_h }
      .map { |hash| split_strings(hash, [:formats]) }
      .map { |hash| split_strings_sym(hash, [:labels]) }
      .map { |hash| split_strings_sym(hash, [:tags]) }
      .map { |hash| nil_to_empty(hash, :labels) }
      .map { |hash| nil_to_empty(hash, :tags) }
      .map { |hash| fav_bool(hash) }
  end

  def hash_to_book(hash)
    Book.new(
      title: hash[:title],
      author: hash[:author],
      status: hash[:status],
      genre: hash[:genre],
      formats: hash[:formats],
      fav: hash[:fav],
      labels: hash[:labels],
      tags: hash[:tags],
      series: hash[:series],
      series_number: hash[:series_number],
    )
  end

  def hashes_to_books(hashes)
    hashes.map { |hash| hash_to_book(hash) }
  end

  def csv_to_books(csv)
    hashes_to_books csv_to_hashes(csv)
  end
end
