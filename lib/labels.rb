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

  def self.not_finishing_label(hash)
    hash['labels'].find{|label| label['name'] == NOT_FINISHING_LABEL}['id']
  end

  def self.favourite_label(hash)
    hash['labels'].find{|label| label['name'] == FAVOURITE_LABEL}['id']
  end
end
