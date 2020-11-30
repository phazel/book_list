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
      "📖 - physical book\n",
      "📱 - ebook\n",
      "🎧 - audiobook\n\n"
    ]
  end

  def self.section(books, header = nil)
    [ line, SECTION_HEADERS[header], books ]
  end

  def self.line
    "---\n\n"
  end

  def self.result(year, total, fav, reg, dnf, current)
    output = Format.header(YEAR, total)
    output += Format.section(fav, :favourites)
    output += Format.section(reg)
    output += Format.section(dnf, :dnf) if dnf.any?
    output += Format.section(current, :currently_reading)
  end
end
