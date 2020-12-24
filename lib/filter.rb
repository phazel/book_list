# frozen_string_literal: true

class Filter
  def self.in_list(books, list)
    books.select do |book|
      book.list_id == list[:id]
    end
  end

  def self.books_with(books, attribute)
    books.select(& attribute)
  end

  def self.books_without(books, attributes)
    books.reject { |book| attributes.any? { |attr| book.public_send(attr) } }
  end

  def self.json_label?(book, label)
    book[:idLabels].include? label[:id]
  end

  def self.duplicates(books)
    books.each_with_object({ dups: [], non_dups: [] }) do |book, result|
      dup_match = result[:dups].find { |dup| dup.matches(book) }
      any_matches = books.select { |book_b| book_b.matches(book) }.size > 1

      if dup_match
        dup_match.add_dup book
      else
        any_matches ? result[:dups].push(book) : result[:non_dups].push(book)
      end
    end
  end
end
