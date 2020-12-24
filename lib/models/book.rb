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

  def with(attr, value)
    valid = %i[series series_number list_id].freeze
    raise ArgumentError, 'invalid attribute' unless valid.include? attr

    book = dup
    book.instance_variable_set("@#{attr}", value)
    book
  end

  def is(attr, cond: true)
    valid = [:audiobook, :ebook, :nat, :sleep, :list_id, :dnf, :fav].freeze
    raise ArgumentError, 'invalid attribute' unless valid.include? attr

    book = dup
    book.instance_variable_set("@#{attr}", true) if cond
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
