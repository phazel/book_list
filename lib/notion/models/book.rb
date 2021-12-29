# frozen_string_literal: true

class Book
  attr_reader :title, :author, :status, :formats

  def initialize(title:, author:, status:, formats:)
    @title  = title
    @author = author
    @status = status
    @formats = formats
  end

  def format_emojis
    audiobook = @formats.include? 'audiobook'
    ebook = @formats.include? 'ebook'
    physical = @formats.include? 'physical'
    "#{'💾' if ebook}#{'🎧' if audiobook}#{'📖' if physical}"
  end

  def to_s
    <<~BOOK
      **#{@title}**
      *by #{@author}*
      Format: #{format_emojis}

    BOOK
  end
end
