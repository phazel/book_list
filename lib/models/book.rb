require_relative '../filter'

class Book
  attr_reader :title, :author, :is_audiobook, :label_ids, :list_id

  def initialize(title, author, is_audiobook, label_ids, list_id)
    @title = title
    @author = author
    @is_audiobook = is_audiobook
    @label_ids = label_ids
    @list_id = list_id
  end

  def self.create_list(json_books, audiobook_label)
    json_books.map do |json_book|
      is_audiobook = Filter.has_label(json_book, audiobook_label)
      Book.new(
        json_book['name'],
        json_book['desc'],
        is_audiobook,
        json_book['idLabels'],
        json_book['idList']
      )
    end
  end
end
