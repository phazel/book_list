class Filter
  def self.in_list(books, list)
    books.select do |book|
      book.list_id == list[:id]
    end
  end

  def self.with_label(books, label)
    books.select { |book| has_label(book, label) }
  end

  def self.without_labels(books, labels)
    books.reject { |book| labels.any? { |label| has_label(book, label) } }
  end

  def self.has_label(book, label)
    book.label_ids.include? label[:id]
  end

  def self.has_json_label(book, label)
    book[:idLabels].include? label[:id]
  end

  def self.duplicates(books)
    books.reduce({ dups: [], non_dups: [] }) do |result, book|
      dup_match = result[:dups].find { |dup| dup.matches(book) }
      any_matches = books.select { |book_b| book_b.matches(book) }.size > 1

      if dup_match
        dup_match.add_dup book
      else
        any_matches ? result[:dups].push(book) : result[:non_dups].push(book)
      end
      result
    end
  end
end
