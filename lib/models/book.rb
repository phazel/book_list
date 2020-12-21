class Book
  attr_reader :title, :author
  attr_accessor :series, :series_number, :is_audiobook, :is_ebook, :with_nat, :for_sleep, :label_ids, :list_id
  AUTHOR_FIELD = 'Author'
  SERIES_FIELD = 'Series'
  SERIES_NUMBER_FIELD = 'Series Number'
  AUDIOBOOK_LABEL = 'audiobook'
  EBOOK_LABEL = 'ebook'
  NATALIE_LABEL = 'nat'
  SLEEP_LABEL = 'sleep'

  def initialize(title:, author:, series: nil, series_number: nil, is_audiobook: false, is_ebook: false, with_nat: false, for_sleep: false, label_ids: [])
    @title = title
    @author = author
    @series = series
    @series_number = series_number
    @is_audiobook = is_audiobook
    @is_ebook = is_ebook
    @with_nat = with_nat
    @for_sleep = for_sleep
    @label_ids = label_ids
  end

  def matches(book)
    book.title == title && book.author == author
  end

  def with_list_id(list_id)
    book = self.dup
    book.list_id = list_id
    return book
  end

  def emojis
    device = @is_audiobook || @is_ebook
    device_emojis = "#{'📱' if @is_ebook}#{'🎧' if @is_audiobook}"

    type = device ? device_emojis : '📖'
    nat = with_nat ? '💞' : ''
    sleep = for_sleep ? '🌒' : ''

    "#{type}#{nat}#{sleep}"
  end

  def to_s
    number_section = "#{", ##{@series_number}" if @series_number}"
    series_section = "#{"\nSeries: #{@series}#{number_section}" if @series}"

    <<~BOOK
    **#{@title}** #{emojis}#{series_section}
    *by #{@author}*

    BOOK
  end

  def self.debug(json_book)
    {
      name: json_book[:name],
      desc: json_book[:desc],
      customFieldItems: json_book[:customFieldItems]
    }
  end
end
