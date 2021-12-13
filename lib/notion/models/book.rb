# frozen_string_literal: true

class Book
  attr_reader :title, :author, :format

  def initialize(title:, author:, format:)
    @title = title
    @author = author
    @format = format
  end
end
