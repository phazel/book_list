require 'models/book'

describe Book do
  let(:title) { 'A Very Good Book' }
  let(:author) { 'Someone Quite Prestigious' }
  let(:is_audiobook) { false }
  let(:is_ebook) { false }
  let(:audio_label) {{ "id"=>"a_id", "name"=>"audiobook" }}
  let(:ebook_label) {{ "id"=>"e_id", "name"=>"ebook" }}
  let(:label_ids) do
    [
      is_audiobook ? audio_label["id"] : [],
      is_ebook ? ebook_label["id"] : []
    ].flatten
  end
  let(:list) {{ "id"=>"list_id", "name"=>"some_list" }}
  let(:is_archived) { false }
  let(:book) do
    Book.new(title, author, is_audiobook, is_ebook, label_ids, list["id"], is_archived)
  end

  describe '#initialize' do
    it { expect(book).to be_a Book }
    it { expect(book.title).to eq title }
    it { expect(book.author).to eq author }
    it { expect(book.is_audiobook).to eq is_audiobook }
    it { expect(book.is_ebook).to eq is_ebook }
    it { expect(book.label_ids).to eq label_ids }
    it { expect(book.list_id).to eq list["id"] }
    it { expect(book.is_archived).to eq is_archived }
  end

  describe '#to_s' do
    context 'when a physical book' do
      let(:pretty_book) { "**A Very Good Book** 📖\n*by Someone Quite Prestigious*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end

    context 'when an audiobook' do
      let(:is_audiobook) { true }
      let(:is_ebook) { false }
      let(:pretty_book) { "**A Very Good Book** 🎧\n*by Someone Quite Prestigious*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end

    context 'when an ebook' do
      let(:is_audiobook) { false }
      let(:is_ebook) { true }
      let(:pretty_book) { "**A Very Good Book** 📱\n*by Someone Quite Prestigious*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end

    context 'when both audiobook and ebook' do
      let(:is_audiobook) { true }
      let(:is_ebook) { true }
      let(:pretty_book) { "**A Very Good Book** 📱🎧\n*by Someone Quite Prestigious*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end
  end

  describe '.create_all' do
    let(:json_book) {{
      "name"=> title,
      "desc"=> author,
      "idLabels"=> label_ids,
      "idList"=> list["id"],
      "closed"=> is_archived
    }}
    let(:hash) {{
      "cards" => [ json_book ],
      "labels" => [ audio_label, ebook_label ]
    }}

    it { expect(Book.create_all(hash)).to all be_a Book }

    it 'matches book attributes' do
      expect(Book.create_all(hash).first).to have_attributes(
        :title => book.title,
        :author => book.author,
        :is_audiobook => book.is_audiobook,
        :is_ebook => book.is_ebook,
        :label_ids => book.label_ids,
        :list_id => book.list_id,
        :is_archived => book.is_archived
      )
    end
  end
end
