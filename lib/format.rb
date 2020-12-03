require_relative 'find'
require_relative 'filter'
require_relative 'models/book'

class Format
  SECTION_HEADERS = {
    fav: "## Favourites:\n\n",
    dnf: "## Books I Decided Not To Finish:\n\n",
    current: "## Books I'm Currently Reading:\n\n"
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

  def self.result(year, read, current)
    output = Format.header(YEAR, read[:count])
    output += Format.section(read[:fav], :fav)
    output += Format.section(read[:regular])
    output += Format.section(read[:dnf], :dnf) if read[:dnf].any?
    output += Format.section(current, :current)
  end

  def self.symbify(item)
    if item.is_a? Hash
      item.map { |k, v| [k, symbify(v)] }.to_h
      item.transform_keys! &:to_sym
    elsif item.respond_to? :map
      item.map { |i| symbify(i) }
    else
      item
    end
  end
end
