class Books
  def self.read_books(hash)
    read_list = hash['lists'].find{|list| list['name'] == READ_LIST }
    hash['cards'].select do |card|
      card['idList'] == read_list['id']
    end
  end

  def self.currently_reading_books(hash)
    currently_reading_list = hash['lists'].find{|list| list['name'] == CURRENTLY_READING_LIST }
    hash['cards'].select do |card|
      card['idList'] == currently_reading_list['id'] && !card['closed']
    end
  end

  def self.present(books)
    books.map do |book|
      <<~SUMMARY
      **#{book['name']}**
      *by #{book['desc']}*

      SUMMARY
    end
  end
end
