require 'models/book'

describe Book do
  let(:title) { 'A Very Good Book' }
  let(:author) { 'Someone Quite Prestigious' }
  let(:is_audiobook) { true }
  let(:audio_label) {{ "id"=>"a_id", "name"=>"audiobook" }}
  let(:list) {{ "id"=>"list_id", "name"=>"some_list" }}
  let(:is_archived) { false }
  let(:book) {
    Book.new(
      title,
      author,
      is_audiobook,
      [ audio_label["id"] ],
      list["id"],
      is_archived
    )}
  let(:json_book) {{
    "name"=> title,
    "desc"=> author,
    "idLabels"=>[ audio_label["id"] ],
    "idList"=> list["id"],
    "closed"=> is_archived
  }}
  let(:hash) {{ "cards" => [ json_book ], "labels" => [ audio_label ] }}

  describe '#initialize' do
    it { expect(book).to be_a Book }
    it { expect(book.title).to eq title }
    it { expect(book.author).to eq author }
    it { expect(book.is_audiobook).to eq is_audiobook }
    it { expect(book.label_ids).to eq [ audio_label["id"] ] }
    it { expect(book.list_id).to eq list["id"] }
    it { expect(book.is_archived).to eq is_archived }
  end

  describe '.create_all' do
    it { expect(Book.create_all(hash)).to all be_a Book }
    it 'matches book attributes' do
      expect(Book.create_all(hash).first).to have_attributes(
        :title => book.title,
        :author => book.author,
        :is_audiobook => book.is_audiobook,
        :label_ids => book.label_ids,
        :list_id => book.list_id,
        :is_archived => book.is_archived
      )
    end
  end
end
