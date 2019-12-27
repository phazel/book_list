require 'format'

books = [
  Book.new('book_1', 'Author 1', false, [], ''),
  Book.new('book_2', 'Author 2', true, [], '')
]

pretty_books = [
  "**book_1**\n*by Author 1*\n\n",
  "**book_2** (Audiobook)\n*by Author 2*\n\n"
]

describe Format do
  describe '.header' do
    let(:year) { 3904 }
    let(:number) { 45 }
    let(:expected_header) {[ "# Books Read In 3904\n", "`Total books read: 45`\n\n" ]}
    it { expect(described_class.header(year, number)).to eq expected_header }
  end

  describe '.section' do
    let(:expected_section) {
      [ "---\n\n", "## Favourites:\n\n", pretty_books ]
    }
    it { expect(described_class.section(books, :favourites)) }
  end

  describe '.pretty' do
    it { expect(described_class.pretty(books)).to eq pretty_books }
  end

  describe '.line' do
    it { expect(described_class.line).to eq [ "---\n\n" ] }
  end
end
