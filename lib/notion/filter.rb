# frozen_string_literal: true

module Filter
  def filter_by_status(books)
    books.group_by { |book| book.status.to_sym }
  end
end
