require 'pry'

class Format
  def self.pretty(books)
    books.map do |book|
      <<~SUMMARY
      **#{book['name']}**
      *by #{book['desc']}*

      SUMMARY
    end
  end

  def self.header(year, number)
    [
      "# Books Read In #{year}\n",
      "`Total books read: #{number}`\n\n\n"
    ]
  end

  def self.favourites(books)
    [
      "## Favourites:\n\n",
      pretty(books),
      line
    ]
  end

  def self.regular_read(books)
    [
      pretty(books),
      line
    ]
  end

  def self.not_finishing(books)
    [
      "## Books I Decided Not To Finish:\n\n",
      pretty(books),
      line
    ]
  end

  def self.currently_reading(books)
    [
      "## Books I'm Currently Reading:\n\n",
      pretty(books)
    ]
  end

  def self.line
    [ "---\n\n" ]
  end
end
