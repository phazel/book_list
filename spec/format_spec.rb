require 'format'

describe Format do
  describe '.header' do
    let(:year) { 3904 }
    let(:number) { 45 }
    let(:expected_header) {
      [
        "# Books Read In #{year}\n",
        "`Total books read: #{number}`\n\n",
        "📖 - physical or ebook\n",
        "🎧 - audiobook\n\n"
      ]
    }

    it { expect(described_class.header(year, number)).to eq expected_header }
  end

  describe '.section' do
    let(:books) {[
      Book.new('book_1', 'Author 1', false, [], '', false),
      Book.new('book_2', 'Author 2', true, [], '', false)
    ]}
    let(:expected_section) {[ "---\n\n", "## Favourites:\n\n", books ]}

    it { expect(described_class.section(books, :favourites)).to eq expected_section }
  end

  describe '.line' do
    it { expect(described_class.line).to eq "---\n\n" }
  end
end
