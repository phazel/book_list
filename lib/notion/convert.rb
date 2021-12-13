require_relative '../notion/models/book'

module Convert
  def split_strings(hash, keys)
    keys.reduce(hash) do |memo, key|
      split_values = memo[key].split(',').map(&:strip)
      memo.merge({ **memo, key => split_values })
    end
  end

  def csv_to_hash(csv)
    CSV::HeaderConverters[:title] = lambda { |header| header == 'Name' ? 'Title' : header }
    CSV::HeaderConverters[:all] = [ :title, :symbol ]
    CSV::Converters[:blank_to_nil] = lambda {|value| value && value.empty? ? nil : value}
    CSV.new(csv, headers: true, header_converters: :all, converters: [:all, :blank_to_nil])
      .map { |row| row.to_h }
      .map { |hash| split_strings(hash, [:format]) }
  end

  def hash_to_book(hash)
    Book.new(title: hash[:title], author: hash[:author], format: hash[:format])
  end
end
