require_relative '../filter'
require_relative '../find'

class Book
  attr_reader :title, :author, :series, :series_number, :is_audiobook, :is_ebook, :label_ids, :list_id, :with_nat
  AUTHOR_FIELD = 'Author'
  SERIES_FIELD = 'Series'
  SERIES_NUMBER_FIELD = 'Series Number'
  AUDIOBOOK_LABEL = 'audiobook'
  EBOOK_LABEL = 'ebook'
  NATALIE_LABEL = 'nat'

  def initialize(title:, author:, series: nil, series_number: nil, is_audiobook: false, is_ebook: false, with_nat: false, label_ids: [], list_id: '')
    @title = title
    @author = author
    @series = series
    @series_number = series_number
    @is_audiobook = is_audiobook
    @is_ebook = is_ebook
    @with_nat = with_nat
    @label_ids = label_ids
    @list_id = list_id
  end

  def to_s
    number_section = "#{", ##{@series_number}" if @series_number}"
    series_section = "#{"\nSeries: #{@series}#{number_section}" if @series}"

    <<~BOOK
    **#{@title}** #{emojis}#{series_section}
    *by #{@author}*

    BOOK
  end

  def matches(book)
    book.title == title && book.author == author
  end

  def emojis
    device = @is_audiobook || @is_ebook
    device_emojis = "#{'📱' if @is_ebook}#{'🎧' if @is_audiobook}"

    type = device ? device_emojis : '📖'
    nat = with_nat ? '👩🏻‍🤝‍👩🏽' : ''

    "#{type}#{nat}"
  end

  def self.debug(json_book)
    {
      name: json_book[:name],
      desc: json_book[:desc],
      customFieldItems: json_book[:customFieldItems]
    }
  end

  def self.custom_field(json_book, field, key, if_not_found: nil)
    if json_book[:customFieldItems]
      found_field = json_book[:customFieldItems]
        .find{ |book_field| book_field[:idCustomField] == field[:id] }
    end

    found_field ? found_field[:value][key] : if_not_found
  end

  def self.from_hash(hash, json_book)
    author_field = Find.custom_field(hash, AUTHOR_FIELD)
    series_field = Find.custom_field(hash, SERIES_FIELD)
    series_number_field = Find.custom_field(hash, SERIES_NUMBER_FIELD)
    audiobook_label = Find.label(hash, AUDIOBOOK_LABEL)
    ebook_label = Find.label(hash, EBOOK_LABEL)
    nat_label = Find.label(hash, NATALIE_LABEL)
    Book.new(
      title: json_book[:name],
      author: Book.custom_field(json_book, author_field, :text, if_not_found: json_book[:desc]),
      series: Book.custom_field(json_book, series_field, :text),
      series_number: Book.custom_field(json_book, series_number_field, :number),
      is_audiobook: Filter.has_json_label(json_book, audiobook_label),
      is_ebook: Filter.has_json_label(json_book, ebook_label),
      with_nat: Filter.has_json_label(json_book, nat_label),
      label_ids: json_book[:idLabels],
      list_id: json_book[:idList],
    )
  end

  def self.all_from_hash(hash)
    hash[:cards]
      .select{ |json_book| !json_book[:closed] }
      .map do |json_book|
        from_hash(hash, json_book)
      end
  end
end
