require_relative '../filter'
require_relative '../find'

class Book
  attr_reader :title, :author, :series, :is_audiobook, :is_ebook, :label_ids, :list_id, :with_nat
  AUTHOR_FIELD = 'Author'
  SERIES_FIELD = 'Series'
  AUDIOBOOK_LABEL = 'audiobook'
  EBOOK_LABEL = 'ebook'
  NATALIE_LABEL = 'nat'

  def initialize(title:, author:, series: nil, is_audiobook: false, is_ebook: false, with_nat: false, label_ids: [], list_id: '')
    @title = title
    @author = author
    @series = series
    @is_audiobook = is_audiobook
    @is_ebook = is_ebook
    @with_nat = with_nat
    @label_ids = label_ids
    @list_id = list_id
  end

  def to_s
    <<~BOOK
    **#{@title}** #{emojis}#{"\nSeries: #{series}" if @series}
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

  def self.author(hash, json_book)
    author_field = Find.custom_field(hash, AUTHOR_FIELD)
    if json_book[:customFieldItems]
      found_author = json_book[:customFieldItems]
        .find{ |field| field[:idCustomField] == author_field[:id] }
    end

    found_author ? found_author[:value][:text] : json_book[:desc]
  end

  def self.series(hash, json_book)
    series_field = Find.custom_field(hash, SERIES_FIELD)
    if json_book[:customFieldItems]
      found_series = json_book[:customFieldItems]
        .find{ |field| field[:idCustomField] == series_field[:id] }
    end

    found_series ? found_series[:value][:text] : nil
  end

  def self.from_json(hash, json_book)
    audiobook_label = Find.label(hash, AUDIOBOOK_LABEL)
    ebook_label = Find.label(hash, EBOOK_LABEL)
    nat_label = Find.label(hash, NATALIE_LABEL)
    Book.new(
      title: json_book[:name],
      author: Book.author(hash, json_book),
      series: Book.series(hash, json_book),
      is_audiobook: Filter.has_json_label(json_book, audiobook_label),
      is_ebook: Filter.has_json_label(json_book, ebook_label),
      with_nat: Filter.has_json_label(json_book, nat_label),
      label_ids: json_book[:idLabels],
      list_id: json_book[:idList],
    )
  end

  def self.create_all(hash)
    hash[:cards]
      .select{ |json_book| !json_book[:closed] }
      .map do |json_book|
        from_json(hash, json_book)
      end
  end
end
