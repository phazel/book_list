class Filter
  def self.with_label(books, label)
    books.select { |book| has_label(book, label) }
  end

  def self.without_labels(books, labels)
    books.reject { |book| labels.any? { |label| has_label(book, label) } }
  end

  def self.has_label(book, label)
    book['idLabels'].include? label["id"]
  end
end
