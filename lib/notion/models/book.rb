# frozen_string_literal: true

class Book
  attr_reader :title, :author, :status, :format

  def initialize(title:, author:, status:, format:)
    @title  = title
    @author = author
    @status   = status
    @format = format
  end
end
