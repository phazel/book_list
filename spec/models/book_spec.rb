require 'models/book'

describe Book do
  let(:title) { 'A Very Good Book' }
  let(:author) { 'Someone Quite Prestigious' }
  let(:json_book) {{ "name"=> title, "desc"=> author }}
  let(:hash) {{ "cards" => [ json_book ] }}
  let(:book) { Book.new(title, author) }

  describe '#initialize' do
    it { expect(book).to be_a Book }
    it { expect(book.title).to eq title }
    it { expect(book.author).to eq author }
  end

  describe '.create_list' do
    it { expect(Book.create_list(hash)).to all be_a Book }
    it 'matches book title and author' do
      expect(Book.create_list(hash).first).to have_attributes(
        :title => book.title,
        :author => book.author
      )
    end
  end
end
