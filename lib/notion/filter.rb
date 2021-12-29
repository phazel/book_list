# frozen_string_literal: true

module Filter
  def filter_by_status(books)
    books.group_by { |book| book.status.to_sym }
  end
  def filter_by_format(books)
    books.inject([]) do |pairs, book|
      book.formats.each { |format| pairs.push [format, book] }
      pairs
    end.group_by { |pair| pair[0] }
    .transform_values { |value| value.map{|item| item[1] } }
    .transform_keys { |key| key.downcase.tr(" ", "_").to_sym }
  end
end
