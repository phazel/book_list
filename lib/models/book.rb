require_relative '../filter'
require_relative '../find'

class Book
  attr_reader :title, :author, :is_audiobook, :is_ebook, :label_ids, :list_id, :is_archived
  AUDIOBOOK_LABEL = 'audiobook'
  EBOOK_LABEL = 'ebook'

  def initialize(title, author, is_audiobook, is_ebook, label_ids, list_id, is_archived)
    @title = title
    @author = author
    @is_audiobook = is_audiobook
    @is_ebook = is_ebook
    @label_ids = label_ids
    @list_id = list_id
    @is_archived = is_archived
  end

  def emojis
    device = @is_audiobook || @is_ebook
    device_emojis = "#{'📱' if @is_ebook}#{'🎧' if @is_audiobook}"

    device ? device_emojis : '📖'
  end

  def to_s
    <<~BOOK
    **#{@title}** #{emojis}
    *by #{@author}*

    BOOK
  end

  def self.create_all(hash)
    audiobook_label = Find.label(hash, AUDIOBOOK_LABEL)
    ebook_label = Find.label(hash, EBOOK_LABEL)

    hash['cards'].map do |json_book|
      is_audiobook = Filter.has_json_label(json_book, audiobook_label)
      is_ebook = Filter.has_json_label(json_book, ebook_label)

      Book.new(
        json_book['name'],
        json_book['desc'],
        is_audiobook,
        is_ebook,
        json_book['idLabels'],
        json_book['idList'],
        json_book['closed']
      )
    end
  end
end
