# frozen_string_literal: true

class Hash
  def splat(*args)
    items = args.reduce([]) {|memo, key| memo.push self[key] }
    results = items.map{|item| item.nil? ? [] : item }
    results.size == 1 ? results.first : results
  end
  def ensure(keys)
    keys.reduce(self) do |memo, key|
      memo[key].nil? ? memo.merge({ key => [] }) : memo
    end
  end
end
