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

  def dup?(book1, book2)
    book1.title == book2.title &&
    book1.author == book2.author &&
    book1 != book2
  end

  def filter_by_dups(books)
    books.each_with_object({ dups: [], non_dups: [] }) do |book, result|
      dup_match = result[:dups].find do |dup_group|
        dup_group.any? { |dup| dup?(dup, book) }
      end
      matches = books.select { |compare| dup?(compare, book) }

      if dup_match
        dup_match.push book
      elsif matches.any?
        result[:dups].push([book])
      else
        result[:non_dups].push book
      end
    end
  end
end
