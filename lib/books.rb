class Books
  def self.present(books)
    books.map do |book|
      <<~SUMMARY
      **#{book['name']}**
      *by #{book['desc']}*

      SUMMARY
    end
  end
end
