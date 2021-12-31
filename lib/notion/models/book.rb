# frozen_string_literal: true

class Book
  attr_reader :title, :author, :status, :genre, :formats, :fav, :labels, :tags, :series, :series_number

  def initialize(title:, author:, status:, genre:, formats:, fav:, labels:, tags:, series: nil, series_number: nil)
    @title  = title
    @author = author
    @status = status
    @genre = genre
    @formats = formats
    @fav = fav
    @labels = labels || []
    @tags = tags || []
    @series = series
    @series_number = series_number
  end

  def format_emojis
    audiobook = @formats.include? 'audiobook'
    ebook = @formats.include? 'ebook'
    physical = @formats.include? 'physical'
    read_aloud = @formats.include? 'read aloud'
    " #{'💾' if ebook}#{'🎧' if audiobook}#{'📖' if physical}#{'🗣' if read_aloud}"
  end

  def fav_emoji
    "#{' 🌟' if @fav}"
  end

  def nat_emoji
    "#{ ' 💞' if @labels.include? :nat }"
  end

  def sleep_emoji
    "#{ ' 💤' if @labels.include? :sleep }"
  end

  def reread_emoji
    "#{ ' 🔁' if @tags.include? :reread }"
  end

  def series_text
    number_text = "##{@series_number} " if @series_number
    "#{" -- *#{number_text}of #{@series}*" if @series}"
  end

  def to_s
    <<~BOOK
      #{fav_emoji}**#{@title}**#{series_text}
      *by #{@author}*
      Format:#{format_emojis}
      Tags:#{nat_emoji}#{sleep_emoji}#{reread_emoji}

    BOOK
  end
end
