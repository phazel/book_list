# frozen_string_literal: true

class Format
  SECTION_HEADERS = {
    dups: "## Books I Read More Than Once!\n\n",
    fav: "## Favourites:\n\n",
    dnf: "## Books I Decided Not To Finish:\n\n",
    current: "## Books I'm Currently Reading:\n\n"
  }.freeze

  def self.header(year, number)
    [
      "# Books Read In #{year}\n",
      "`Total books read: #{number}`\n\n",
      "📖 - physical book\n",
      "📱 - ebook\n",
      "🎧 - audiobook\n",
      "💞 - I read this with my partner\n",
      "🌒 - I listened to this book to go to sleep\n\n"
    ]
  end

  def self.section(books, header = nil)
    [ line, SECTION_HEADERS[header], books ]
  end

  def self.line
    "---\n\n"
  end

  def self.result(year, read, current)
    [
      header(year, read[:count]),
      section(read[:dups], :dups),
      section(read[:fav], :fav),
      section(read[:regular]),
      (section(read[:dnf], :dnf) if read[:dnf].any?),
      section(current, :current)
    ]
  end

  def self.symbify(item)
    if item.is_a? Hash
      item.transform_values { |v| symbify(v) }
      item.transform_keys!(&:to_sym)
    elsif item.respond_to? :map
      item.map { |i| symbify(i) }
    else
      item
    end
  end
end
