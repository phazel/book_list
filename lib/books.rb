class Books

  def self.find(hash, list_name)
    list = hash['lists'].find{|list| list['name'] == list_name }
    hash['cards'].select do |card|
      card['idList'] == list['id'] && !card['closed']
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
