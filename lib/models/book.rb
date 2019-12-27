require_relative '../filter'

class Book
  attr_reader :title, :author, :is_audiobook, :label_ids

  def initialize(title, author, is_audiobook, label_ids)
    @title = title
    @author = author
    @is_audiobook = is_audiobook
    @label_ids = label_ids
  end

  def self.create_list(hash, audiobook_label)
    books = hash.is_a?(Hash) ? hash['cards'] : hash # TEMP
    books.map do |json_book|
      is_audiobook = Filter.has_label(json_book, audiobook_label)
      Book.new(json_book['name'], json_book['desc'], is_audiobook, json_book['idLabels'])
    end
  end
end
