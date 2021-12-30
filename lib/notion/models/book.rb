# frozen_string_literal: true

class Book
  attr_reader :title, :author, :status, :formats, :fav

  def initialize(title:, author:, status:, formats:, fav:)
    @title  = title
    @author = author
    @status = status
    @formats = formats
    @fav = fav
  end

  def format_emojis
    audiobook = @formats.include? 'audiobook'
    ebook = @formats.include? 'ebook'
    physical = @formats.include? 'physical'
    "#{'💾' if ebook}#{'🎧' if audiobook}#{'📖' if physical}"
  end

  def fav_emoji
    "#{' 🌟' if @fav}"
  end

  def to_s
    <<~BOOK
      **#{@title}**#{fav_emoji}
      *by #{@author}*
      Format: #{format_emojis}

    BOOK
  end
end
