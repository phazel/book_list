class Book
  attr_reader :title, :author
  attr_accessor :series, :series_number, :audiobook, :ebook, :nat, :sleep, :label_ids, :list_id
  AUTHOR_FIELD = 'Author'
  SERIES_FIELD = 'Series'
  SERIES_NUMBER_FIELD = 'Series Number'
  AUDIOBOOK_LABEL = 'audiobook'
  EBOOK_LABEL = 'ebook'
  NATALIE_LABEL = 'nat'
  SLEEP_LABEL = 'sleep'

  def initialize(title:, author:, series: nil, series_number: nil)
    @title = title
    @author = author
    @series = series
    @series_number = series_number
    @label_ids = []
    @audiobook = @ebook = @nat = @sleep = false
  end

  def matches(book)
    book.title == title && book.author == author
  end

  def with_series(series)
    book = self.dup
    book.series = series
    return book
  end

  def with_series_number(series_number)
    book = self.dup
    book.series_number = series_number
    return book
  end

  def with_audiobook(cond = true)
    book = self.dup
    book.audiobook = true if cond
    return book
  end

  def with_ebook(cond = true)
    book = self.dup
    book.ebook = true if cond
    return book
  end

  def with_nat(cond = true)
    book = self.dup
    book.nat = true if cond
    return book
  end

  def with_sleep(cond = true)
    book = self.dup
    book.sleep = true if cond
    return book
  end

  def with_label_ids(label_ids)
    book = self.dup
    book.label_ids = label_ids
    return book
  end

  def with_list_id(list_id)
    book = self.dup
    book.list_id = list_id
    return book
  end

  def emojis
    device = @audiobook || @ebook
    device_emojis = "#{'📱' if @ebook}#{'🎧' if @audiobook}"

    type_emojis = device ? device_emojis : '📖'
    nat_emojis = @nat ? '💞' : ''
    sleep_emojis = @sleep ? '🌒' : ''

    "#{type_emojis}#{nat_emojis}#{sleep_emojis}"
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
