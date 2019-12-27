require 'models/book'

describe Book do
  let(:title) { 'A Very Good Book' }
  let(:author) { 'Someone Quite Prestigious' }
  let(:is_audiobook) { true }
  let(:audio_label) {{ "id"=>"a_id", "name"=>"audiobook" }}
  let(:json_book) {{ "name"=> title, "desc"=> author, "idLabels"=>[audio_label["id"]] }}
  let(:hash) {{ "cards" => [ json_book ] }}
  let(:book) { Book.new(title, author, is_audiobook) }

  describe '#initialize' do
    it { expect(book).to be_a Book }
    it { expect(book.title).to eq title }
    it { expect(book.author).to eq author }
    it { expect(book.is_audiobook).to eq is_audiobook }
  end

  describe '.create_list' do
    it { expect(Book.create_list(hash, audio_label)).to all be_a Book }
    it 'matches book title and author' do
      expect(Book.create_list(hash, audio_label).first).to have_attributes(
        :title => book.title,
        :author => book.author,
        :is_audiobook => book.is_audiobook
      )
    end
  end
end
