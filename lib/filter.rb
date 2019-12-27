class Filter
  def self.in_list(books, list)
    books.select do |book|
      book['idList'] == list['id'] && !book['closed']
    end
  end

  def self.with_label(books, label)
    books.select { |book| has_label(book, label) }
  end

  def self.without_labels(books, labels)
    books.reject { |book| labels.any? { |label| has_label(book, label) } }
  end

  def self.has_label(book, label)
    labels = book.is_a?(Hash) ? book['idLabels'] : book.label_ids # TEMP
    labels.include? label["id"]
  end
end
