# frozen_string_literal: true

require 'format'
require 'models/book'

describe Format do
  describe '.header' do
    let(:year) { 3904 }
    let(:number) { 45 }
    let(:expected_header) do
      [
        "# Books Read In #{year}\n",
        "`Total books read: #{number}`\n\n",
        "📖 - physical book\n",
        "📱 - ebook\n",
        "🎧 - audiobook\n",
        "👩🏻‍🦱 - I read this with my partner\n",
        "🌒 - I listened to this book to go to sleep\n\n"
      ]
    end

    it { expect(described_class.header(year, number)).to eq expected_header }
  end

  describe '.section' do
    let(:books) do
      [
        Book.new(title: 'book_1', author: 'Author 1'),
        Book.new(title: 'book_2', author: 'Author 2').is(:audiobook)
      ]
    end
    let(:expected_section) { [ "---\n\n", "## Favourites:\n\n", books ] }

    it { expect(described_class.section(books, :fav)).to eq expected_section }
  end

  describe '.line' do
    it { expect(described_class.line).to eq "---\n\n" }
  end

  describe '.symbify' do
    string_keys = { 'a' => 1, 'b' => { 'c' => 'd', 'e' => [{ 'f' => 'g' }] } }
    sym_keys = { a: 1, b: { c: 'd', e: [{ f: 'g' }] } }
    it { expect(described_class.symbify(string_keys)).to eq sym_keys }
  end

  describe '.strip' do
    with_spaces = { a: '1 ', b: { c: ' d ', e: [{ f: ' g 2 ', h: nil, i: ' ', j: '' }] } }
    stripped    = { a: '1',  b: { c: 'd',  e: [{ f: 'g 2' , h: nil, i: '',  j: '' }] } }
    it { expect(described_class.strip('2 ')).to eq '2' }
    it { expect(described_class.strip(with_spaces)).to eq stripped }
  end
end
