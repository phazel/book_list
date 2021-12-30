# frozen_string_literal: true

require 'csv'
require_relative '../notion/models/book'
require_relative './helpers'
include Helpers::Convert

module Convert
  def split_strings(hash, keys)
    keys.reduce(hash) do |memo, key|
      split_values = memo[key].split(',').map(&:strip)
      memo.merge({ **memo, key => split_values })
    end
  end

  def fav_bool(hash)
    hash.merge({ fav: hash[:fav].to_s.downcase == 'yes' })
  end

  def csv_to_hashes(csv)
    csv_converters
    CSV.new(csv, headers: true, header_converters: :all, converters: :mine)
      .map { |row| row.to_h }
      .map { |hash| split_strings(hash, [:formats]) }
      .map { |hash| fav_bool(hash) }
  end

  def hash_to_book(hash)
    Book.new(
      title: hash[:title],
      author: hash[:author],
      status: hash[:status],
      formats: hash[:formats],
      fav: hash[:fav],
    )
  end

  def hashes_to_books(hashes)
    hashes.map { |hash| hash_to_book(hash) }
  end

  def csv_to_books(csv)
    hashes_to_books csv_to_hashes(csv)
  end
end
