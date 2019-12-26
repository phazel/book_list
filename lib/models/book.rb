class Book
  attr_reader :title, :author

  def initialize(title, author)
    @title = title
    @author = author
  end

  def self.create_list(hash)
    hash['cards'].map do |json_book|
      Book.new(json_book['name'], json_book['desc'])
    end
  end
end
