# frozen_string_literal: true

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
  def self.READ_LIST(year) "Read #{year}" end

  def self.lists(hash, year)
    replace = { READ_LIST(year) => "read", CURRENTLY_READING_LIST => "current" }

    hash[:lists].map do |list|
      replacement = replace[list[:name]]
      replacement ? list.merge({ name: replacement }) : list
    end
  rescue NoMethodError; nil
  end

  def self.label(hash, label_name)
    hash[:labels].find { |label| label[:name] == label_name }
  end

  def self.custom_field(hash, field_name)
    found = hash[:customFields].find { |field| field[:name] == field_name }
    found ? found.merge(type: found[:type].to_sym) : nil
  end

  def  self.book_list(json_book_list_id, lists)
    found = lists.find{ |list| list[:id] == json_book_list_id }
    found ? found[:name] : nil
  end

  def self.book_custom_field(json_book, field, default: nil)
    if json_book[:customFieldItems]
      found_field = json_book[:customFieldItems].find do |book_field|
        book_field[:idCustomField] == field[:id]
      end
    end

    found_field ? found_field[:value][field[:type]] : default
  end

  def self.json_label?(json_book, label)
    json_book[:idLabels] && label ? json_book[:idLabels].include?(label[:id]) : false
  end

  def self.all_books(hash, year)
    hash[:cards]
    .reject { |json_book| json_book[:closed] }
    .map { |json_book| book(hash, json_book, Extract.lists(hash, year)) }
    .reject { |book| book.list.nil? }
  end

  def self.book(hash, json_book, lists)
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
      author: book_custom_field(json_book, author_field, default: json_book[:desc])
    )
        .with(series: book_custom_field(json_book, series_field))
        .with(series_number: book_custom_field(json_book, series_number_field))
        .with(list: book_list(json_book[:idList], lists))
        .is(:audiobook, cond: json_label?(json_book, audiobook_label))
        .is(:ebook, cond: json_label?(json_book, ebook_label))
        .is(:nat, cond: json_label?(json_book, nat_label))
        .is(:sleep, cond: json_label?(json_book, sleep_label))
        .is(:dnf, cond: json_label?(json_book, dnf_label))
        .is(:fav, cond: json_label?(json_book, fav_label))
  end
end
