require_relative 'find'
require_relative 'filter'

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

  def self.section(books, header = nil)
    [ line, SECTION_HEADERS[header], pretty(books) ]
  end

  def self.pretty(books)
    books.map do |book|
      <<~SUMMARY
      **#{book['name']}**#{' (Audiobook)' if book['audiobook']}
      *by #{book['desc']}*

      SUMMARY
    end
  end

  def self.add_audiobook(hash, audiobook_label)
    hash['cards'].map do |book|
      audiobook = { 'audiobook'=> Filter.has_label(book, audiobook_label) }
      book.merge(audiobook)
    end
  end

  def self.line
    [ "---\n\n" ]
  end
end
