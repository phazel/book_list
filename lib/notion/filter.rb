# frozen_string_literal: true

require_relative './models/hash'

module Filter
  def filter_by_status(books)
    books.group_by { |book| book.status.to_sym }
    .ensure([:done, :current])
  end

  def filter_by_format(books)
    books.inject([]) do |pairs, book|
      book.formats.each { |format| pairs.push [format, book] }
      pairs
    end.group_by { |pair| pair[0] }
      .transform_values { |value| value.map{|pair| pair[1] } }
      .transform_keys { |key| key.downcase.tr(" ", "_").to_sym }
      .ensure([:audiobook, :ebook, :physical, :read_aloud])
  end

  def filter_by_fav(books)
    books.group_by { |book| book.fav ? :fav : :non_fav }
      .ensure([:fav, :non_fav])
  end

  def filter_by_nat(books)
    books.group_by { |book| book.labels.include?(:nat) ? :nat : :non_nat }
      .ensure([:nat, :non_nat])
  end

  def filter_by_sleep(books)
    books.group_by { |book| book.labels.include?(:sleep) ? :sleep : :non_sleep }
      .ensure([:sleep, :non_sleep])
  end

  def filter_by_reread(books)
    books.group_by { |book| book.tags.include?(:reread) ? :reread : :non_reread }
      .ensure([:reread, :non_reread])
  end

  def filter_by_dnf(books)
    books.group_by { |book| book.tags.include?(:dnf) ? :dnf : :non_dnf }
      .ensure([:dnf, :non_dnf])
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
    end.ensure([:dups, :non_dups])
  end

  def dedup(books)
    sorted = filter_by_dups(books)
    dups = sorted[:dups].map{|group| dedupe_group(group)}
    non_dups = sorted[:non_dups]
    {
      dups: dups,
      non_dups: non_dups,
      all: dups + non_dups,
    }
  end

  def dedupe_status(status1, status2)
    order = [ 'done', 'current' ]
    order.each do |compare|
      return status1 if status1 == compare
      return status2 if status2 == compare
    end
    return status1
  end

  def dedupe_formats(formats1, formats2)
    (formats1 + formats2).uniq
  end

  def dedupe_fav(fav1, fav2)
    fav1 || fav2
  end

  def dedupe_labels(labels1, labels2)
    (labels1 + labels2).uniq
  end

  def dedupe_tags(tags1, tags2)
    (tags1 + tags2).uniq
  end

  def dedupe_book(book1, book2)
    throw StandardError.new('Books must be duplicates') unless dup?(book1, book2)
    Book.new(
      title: book1.title,
      author: book1.author,
      status: dedupe_status(book1.status, book2.status),
      formats: dedupe_formats(book1.formats, book2.formats),
      fav: dedupe_fav(book1.fav, book2.fav),
      labels: dedupe_labels(book1.labels, book2.labels),
      tags: dedupe_tags(book1.tags, book2.tags),
    )
  end

  def dedupe_group(group)
    group.reduce { |result, book| dedupe_book(result, book) }
  end
end
