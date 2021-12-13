module Convert
  def split_strings(hash, keys)
    keys.reduce(hash) do |memo, key|
      split_values = memo[key].split(',').map(&:strip)
      memo.merge({ **memo, key => split_values })
    end
  end

  def csv_to_hash(csv)
    CSV::Converters[:blank_to_nil] = lambda {|value| value && value.empty? ? nil : value}
    CSV.new(csv, headers: true, header_converters: :symbol, converters: [:all, :blank_to_nil])
      .map { |row| row.to_h }
      .map { |hash| split_strings(hash, [:format]) }
  end
end
