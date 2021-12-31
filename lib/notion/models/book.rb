# frozen_string_literal: true

class Book
  attr_reader :title, :author, :status, :formats, :fav, :labels, :tags

  def initialize(title:, author:, status:, formats:, fav:, labels:, tags:)
    @title  = title
    @author = author
    @status = status
    @formats = formats
    @fav = fav
    @labels = labels || []
    @tags = tags || []
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

  def to_s
    <<~BOOK
      **#{@title}**#{fav_emoji}
      *by #{@author}*
      Format:#{format_emojis}
      Tags:#{nat_emoji}#{sleep_emoji}#{reread_emoji}

    BOOK
  end
end
