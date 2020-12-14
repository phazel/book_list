require_relative './filter'
require_relative './find'
require_relative './models/book'

class Convert
  AUTHOR_FIELD = 'Author'
  SERIES_FIELD = 'Series'
  SERIES_NUMBER_FIELD = 'Series Number'
  AUDIOBOOK_LABEL = 'audiobook'
  EBOOK_LABEL = 'ebook'
  NATALIE_LABEL = 'nat'
  SLEEP_LABEL = 'sleep'

  def self.custom_field(json_book, field, key, default: nil)
    if json_book[:customFieldItems]
      found_field = json_book[:customFieldItems]
        .find{ |book_field| book_field[:idCustomField] == field[:id] }
    end

    found_field ? found_field[:value][key] : default
  end

  def self.book(hash, json_book)
    author_field = Find.custom_field(hash, AUTHOR_FIELD)
    series_field = Find.custom_field(hash, SERIES_FIELD)
    series_number_field = Find.custom_field(hash, SERIES_NUMBER_FIELD)
    audiobook_label = Find.label(hash, AUDIOBOOK_LABEL)
    ebook_label = Find.label(hash, EBOOK_LABEL)
    nat_label = Find.label(hash, NATALIE_LABEL)
    sleep_label = Find.label(hash, SLEEP_LABEL)
    Book.new(
      title: json_book[:name],
      author: custom_field(json_book, author_field, :text, default: json_book[:desc]),
      series: custom_field(json_book, series_field, :text),
      series_number: custom_field(json_book, series_number_field, :number),
      is_audiobook: Filter.has_json_label(json_book, audiobook_label),
      is_ebook: Filter.has_json_label(json_book, ebook_label),
      with_nat: Filter.has_json_label(json_book, nat_label),
      for_sleep: Filter.has_json_label(json_book, sleep_label),
      label_ids: json_book[:idLabels],
      list_id: json_book[:idList],
    )
  end

  def self.all_books(hash)
    hash[:cards]
      .select{ |json_book| !json_book[:closed] }
      .map { |json_book| book(hash, json_book) }
  end
end
