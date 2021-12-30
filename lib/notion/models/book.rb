# frozen_string_literal: true

class Book
  attr_reader :title, :author, :status, :formats, :fav, :labels

  def initialize(title:, author:, status:, formats:, fav:, labels:)
    @title  = title
    @author = author
    @status = status
    @formats = formats
    @fav = fav
    @labels = labels || []
  end

  def format_emojis
    audiobook = @formats.include? 'audiobook'
    ebook = @formats.include? 'ebook'
    physical = @formats.include? 'physical'
    " #{'💾' if ebook}#{'🎧' if audiobook}#{'📖' if physical}"
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

  def to_s
    <<~BOOK
      **#{@title}**#{fav_emoji}
      *by #{@author}*
      Format:#{format_emojis}
      Tags:#{nat_emoji}#{sleep_emoji}

    BOOK
  end
end
