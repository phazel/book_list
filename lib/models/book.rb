# frozen_string_literal: true

class Book
  attr_reader :title, :author, :duplicates
  attr_accessor :series, :series_number, :audiobook, :ebook, :nat, :sleep, :list_id,
                :dnf, :fav

  def initialize(title:, author:)
    @title = title
    @author = author
    @series = @series_number = @list_id = nil
    @audiobook = @ebook = @nat = @sleep = @dnf = @fav = false
    @duplicates = []
  end

  def matches(book)
    book.title == title && book.author == author
  end

  def with_series(series)
    book = dup
    book.series = series
    book
  end

  def with_series_number(series_number)
    book = dup
    book.series_number = series_number
    book
  end

  def with_list_id(list_id)
    book = dup
    book.list_id = list_id
    book
  end

  def with_audiobook(cond: true)
    book = dup
    book.audiobook = true if cond
    book
  end

  def with_ebook(cond: true)
    book = dup
    book.ebook = true if cond
    book
  end

  def with_nat(cond: true)
    book = dup
    book.nat = true if cond
    book
  end

  def with_sleep(cond: true)
    book = dup
    book.sleep = true if cond
    book
  end

  def with_dnf(cond: true)
    book = dup
    book.dnf = true if cond
    book
  end

  def with_fav(cond: true)
    book = dup
    book.fav = true if cond
    book
  end

  def add_dup(dup_book)
    @duplicates.push dup_book
    self
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
    number_section = (", ##{@series_number}" if @series_number).to_s
    series_section = ("\nSeries: #{@series}#{number_section}" if @series).to_s

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
