class Filter
  def self.in_list(books, list)
    books.select do |book|
      book.list_id == list['id']
    end
  end

  def self.with_label(books, label)
    books.select { |book| has_label(book, label) }
  end

  def self.without_labels(books, labels)
    books.reject { |book| labels.any? { |label| has_label(book, label) } }
  end

  def self.has_label(book, label)
    book.label_ids.include? label["id"]
  end

  def self.has_json_label(book, label)
    book['idLabels'].include? label["id"]
  end
end
