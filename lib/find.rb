class Find
  def self.list(hash, list_name)
    hash['lists'].find{ |list| list['name'] == list_name }
  end

  def self.label(hash, label_name)
    hash['labels'].find{ |label| label['name'] == label_name }
  end
end
