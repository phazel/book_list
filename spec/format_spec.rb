require 'format'

describe Format do
  describe '.header' do
    let(:year) { 3904 }
    let(:number) { 45 }
    let(:expected_header) {
      [
        "# Books Read In #{year}\n",
        "`Total books read: #{number}`\n\n",
        "📖 - physical book\n",
        "📱 - ebook\n",
        "🎧 - audiobook\n",
        "💞 - I read this with my partner\n",
        "🌒 - I listened to this book to go to sleep\n\n"
      ]
    }

    it { expect(described_class.header(year, number)).to eq expected_header }
  end

  describe '.section' do
    let(:books) {[
      Book.new(title: 'book_1', author: 'Author 1'),
      Book.new(title: 'book_2', author: 'Author 2').with_audiobook,
    ]}
    let(:expected_section) {[ "---\n\n", "## Favourites:\n\n", books ]}

    it { expect(described_class.section(books, :fav)).to eq expected_section }
  end

  describe '.line' do
    it { expect(described_class.line).to eq "---\n\n" }
  end

  describe '.symbify' do
    json = { "a"=>1, "b"=>{ "c"=>"d", "e"=>[{ "f"=> "g" }] } }
    hash = { a: 1, b: { c: "d", e: [{ f: "g" }] } }
    it { expect(described_class.symbify json).to eq hash }
  end
end
