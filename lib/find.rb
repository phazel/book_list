class Find
  def self.books_in_list(hash, list_name)
    list = list(hash, list_name)
    hash['cards'].select do |card|
      card['idList'] == list['id'] && !card['closed']
    end
  end

  def self.list(hash, list_name)
    hash['lists'].find{|list| list['name'] == list_name }
  end

  def self.label(hash, label_name)
    hash['labels'].find{|label| label['name'] == label_name}
  end
end
