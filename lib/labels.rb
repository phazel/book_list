class Labels
  def self.with_label(books, label)
    books.select { |book| Labels.has_label(book, label) }
  end

  def self.without_labels(books, labels)
    books.reject { |book| labels.any? { |label| Labels.has_label(book, label) } }
  end

  def self.has_label(book, label)
    book['idLabels'].include? label["id"]
  end

  def self.find(hash, label_name)
    hash['labels'].find{|label| label['name'] == label_name}
  end
end
