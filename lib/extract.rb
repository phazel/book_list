# frozen_string_literal: true

require_relative './filter'
require_relative './models/book'

class Extract
  AUTHOR_FIELD = 'Author'
  SERIES_FIELD = 'Series'
  SERIES_NUMBER_FIELD = 'Series Number'
  AUDIOBOOK_LABEL = 'audiobook'
  EBOOK_LABEL = 'ebook'
  NATALIE_LABEL = 'nat'
  SLEEP_LABEL = 'sleep'

  FAVOURITE_LABEL = 'fav'
  DNF_LABEL = 'dnf'
  CURRENTLY_READING_LIST = '📖 Reading 📖'
  def self.read_list(year)
    "Read #{year}"
  end

  def self.list(hash, list_name)
    hash[:lists].find { |list| list[:name] == list_name }
  end

  def self.lists(hash, year, list_names = nil)
    if list_names.nil?
      {
        read: list(hash, read_list(year)),
        current: list(hash, CURRENTLY_READING_LIST)
      }
    else
      list_names.map { |name| [ name.to_sym, list(hash, name) ] }.to_h
    end
  end

  def self.label(hash, label_name)
    hash[:labels].find { |label| label[:name] == label_name }
  end

  def self.labels(hash, label_names = [FAVOURITE_LABEL, DNF_LABEL])
    label_names.map { |name| [ name.to_sym, label(hash, name) ] }.to_h
  end

  def self.custom_field(hash, field_name)
    hash[:customFields].find { |field| field[:name] == field_name }
  end

  def self.book_custom_field(json_book, field, key, default: nil)
    if json_book[:customFieldItems]
      found_field = json_book[:customFieldItems].find do |book_field|
        book_field[:idCustomField] == field[:id]
      end
    end

    found_field ? found_field[:value][key] : default
  end

  def self.book(hash, json_book)
    author_field = custom_field(hash, AUTHOR_FIELD)
    series_field = custom_field(hash, SERIES_FIELD)
    series_number_field = custom_field(hash, SERIES_NUMBER_FIELD)
    audiobook_label = label(hash, AUDIOBOOK_LABEL)
    ebook_label = label(hash, EBOOK_LABEL)
    nat_label = label(hash, NATALIE_LABEL)
    sleep_label = label(hash, SLEEP_LABEL)
    dnf_label = label(hash, DNF_LABEL)
    fav_label = label(hash, FAVOURITE_LABEL)

    Book.new(
      title: json_book[:name],
      author: book_custom_field(json_book, author_field, :text, default: json_book[:desc])
    )
        .with_series(book_custom_field(json_book, series_field, :text))
        .with_series_number(book_custom_field(json_book, series_number_field, :number))
        .with_label_ids(json_book[:idLabels])
        .with_list_id(json_book[:idList])
        .with_audiobook(cond: Filter.json_label?(json_book, audiobook_label))
        .with_ebook(cond: Filter.json_label?(json_book, ebook_label))
        .with_nat(cond: Filter.json_label?(json_book, nat_label))
        .with_sleep(cond: Filter.json_label?(json_book, sleep_label))
        .with_dnf(cond: Filter.json_label?(json_book, dnf_label))
        .with_fav(cond: Filter.json_label?(json_book, fav_label))
  end

  def self.all_books(hash)
    hash[:cards]
      .reject { |json_book| json_book[:closed] }
      .map { |json_book| book(hash, json_book) }
  end
end
