require_relative '../filter'
require_relative '../find'

class Book
  attr_reader :title, :author, :is_audiobook, :is_ebook, :label_ids, :list_id
  AUTHOR_FIELD = 'Author'
  AUDIOBOOK_LABEL = 'audiobook'
  EBOOK_LABEL = 'ebook'

  def initialize(title, author, is_audiobook, is_ebook, label_ids, list_id)
    @title = title
    @author = author
    @is_audiobook = is_audiobook
    @is_ebook = is_ebook
    @label_ids = label_ids
    @list_id = list_id
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

  def matches(book)
    book.title == title && book.author == author
  end

  def self.debug(json_book)
    {
      name: json_book[:name],
      desc: json_book[:desc],
      customFieldItems: json_book[:customFieldItems]
    }
  end

  def self.create_all(hash)
    author_field = Find.custom_field(hash, AUTHOR_FIELD)
    audiobook_label = Find.label(hash, AUDIOBOOK_LABEL)
    ebook_label = Find.label(hash, EBOOK_LABEL)

    hash[:cards]
      .select{ |json_book| !json_book[:closed] }
      .map do |json_book|
        if json_book[:customFieldItems]
          found_author = json_book[:customFieldItems]
            .find{ |field| field[:idCustomField] == author_field[:id] }
        end
        author = found_author ? found_author[:value][:text] : json_book[:desc]

        is_audiobook = Filter.has_json_label(json_book, audiobook_label)
        is_ebook = Filter.has_json_label(json_book, ebook_label)

        Book.new(
          json_book[:name],
          author,
          is_audiobook,
          is_ebook,
          json_book[:idLabels],
          json_book[:idList]
        )
      end
  end
end
