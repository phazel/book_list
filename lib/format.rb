require_relative 'find'
require_relative 'filter'
require_relative 'models/book'

class Format
  SECTION_HEADERS = {
    favourites: "## Favourites:\n\n",
    not_finishing: "## Books I Decided Not To Finish:\n\n",
    currently_reading: "## Books I'm Currently Reading:\n\n"
  }

  def self.header(year, number)
    [
      "# Books Read In #{year}\n",
      "`Total books read: #{number}`\n\n"
    ]
  end

  def self.section(json_books, audiobook_label, header = nil)
    books = Book.create_list(json_books, audiobook_label)
    [ line, SECTION_HEADERS[header], pretty(books) ]
  end

  def self.pretty(books)
    books.map do |book|
      <<~SUMMARY
      **#{book.title}**#{' (Audiobook)' if book.is_audiobook}
      *by #{book.author}*

      SUMMARY
    end
  end

  def self.line
    [ "---\n\n" ]
  end
end
