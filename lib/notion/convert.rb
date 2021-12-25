# frozen_string_literal: true

require 'csv'
require_relative '../notion/models/book'

module Convert
  def split_strings(hash, keys)
    keys.reduce(hash) do |memo, key|
      split_values = memo[key].split(',').map(&:strip)
      memo.merge({ **memo, key => split_values })
    end
  end

  ALT_STATUSES = {
    '📖 Reading 📖' => 'current',
    'Read 2021' => 'done',
  }

  def csv_to_hashes(csv)
    CSV::HeaderConverters[:title] = lambda { |header| header == 'Name' ? 'Title' : header }
    CSV::HeaderConverters[:all] = [ :title, :symbol ]
    CSV::Converters[:blank_to_nil] = lambda {|value| value && value.empty? ? nil : value}
    CSV::Converters[:status] = lambda {|status| ALT_STATUSES.include?(status) ? ALT_STATUSES[status] : status}
    CSV::Converters[:mine] = [ :all, :blank_to_nil, :status ]
    CSV.new(csv, headers: true, header_converters: :all, converters: :mine)
      .map { |row| row.to_h }
      .map { |hash| split_strings(hash, [:format]) }
  end

  def hash_to_book(hash)
    Book.new(
      title: hash[:title],
      author: hash[:author],
      status: hash[:status],
      format: hash[:format]
    )
  end

  def hashes_to_books(hashes)
    hashes.map { |hash| hash_to_book(hash) }
  end

  def csv_to_books(csv)
    hashes_to_books csv_to_hashes(csv)
  end
end
