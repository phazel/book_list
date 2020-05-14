require_relative 'find'
require_relative 'filter'
require_relative 'models/book'

class Format
  SECTION_HEADERS = {
    favourites: "## Favourites:\n\n",
    dnf: "## Books I Decided Not To Finish:\n\n",
    currently_reading: "## Books I'm Currently Reading:\n\n"
  }

  def self.header(year, number)
    [
      "# Books Read In #{year}\n",
      "`Total books read: #{number}`\n\n",
      "📖 - physical or ebook\n",
      "🎧 - audiobook\n\n"
    ]
  end

  def self.section(books, header = nil)
    [ line, SECTION_HEADERS[header], books ]
  end

  def self.line
    "---\n\n"
  end
end
