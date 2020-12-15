require_relative 'filter'
require_relative 'models/book'

class Format
  SECTION_HEADERS = {
    dups: "## Books I Read More Than Once!\n\n",
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
    output = header(YEAR, read[:count])
    output += section(read[:dups], :dups)
    output += section(read[:fav], :fav)
    output += section(read[:regular])
    output += section(read[:dnf], :dnf) if read[:dnf].any?
    output += section(current, :current)
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
