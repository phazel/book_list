require_relative '../filter'
require_relative '../find'

class Book
  attr_reader :title, :author, :is_audiobook, :label_ids, :list_id, :is_archived
  AUDIOBOOK_LABEL = 'audiobook'

  def initialize(title, author, is_audiobook, label_ids, list_id, is_archived)
    @title = title
    @author = author
    @is_audiobook = is_audiobook
    @label_ids = label_ids
    @list_id = list_id
    @is_archived = is_archived
  end

  def to_s
    <<~BOOK
    **#{@title}**#{' (Audiobook)' if @is_audiobook}
    *by #{@author}*

    BOOK
  end

  def self.create_all(hash)
    audiobook_label = Find.label(hash, AUDIOBOOK_LABEL)
    hash['cards'].map do |json_book|
      is_audiobook = Filter.has_label(json_book, audiobook_label)
      Book.new(
        json_book['name'],
        json_book['desc'],
        is_audiobook,
        json_book['idLabels'],
        json_book['idList'],
        json_book['closed']
      )
    end
  end
end
