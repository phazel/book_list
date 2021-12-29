# frozen_string_literal: true

class Book
  attr_reader :title, :author, :status, :formats

  def initialize(title:, author:, status:, formats:)
    @title  = title
    @author = author
    @status = status
    @formats = formats
  end

  def to_s
    <<~BOOK
      **#{@title}**
      *by #{@author}*

    BOOK
  end
end
