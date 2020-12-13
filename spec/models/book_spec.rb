require 'models/book'

describe Book do
  let(:list) {{ id: "list_id", name:"some_list" }}
  let(:audio_label) {{ id: "a_id", name: "audiobook" }}
  let(:ebook_label) {{ id: "e_id", name: "ebook" }}
  let(:nat_label) {{ id: "n_id", name: "nat" }}
  let(:author_field) {{ id: "af_id", name: "Author" }}
  let(:series_field) {{ id: "sf_id", name: "Series" }}
  let(:json_book) {{
    name: 'A Very Good Book',
    desc: "Ghost Writer",
    idLabels: [],
    idList: list[:id],
    customFieldItems: [{
      idCustomField: "af_id",
      value: { text: 'Pretty Good Writer' },
    }]
  }}
  let(:hash) {{
    cards: [ json_book ],
    lists: [ list ],
    labels: [ audio_label, ebook_label, nat_label ],
    customFields: [ author_field, series_field ]
  }}

  let(:book) do
    Book.new(
      title: 'A Very Good Book',
      author: 'Pretty Good Writer',
      list_id: list[:id],
    )
  end

  describe '#initialize' do
    it { expect(book).to be_a Book }
    it { expect(book.title).to eq 'A Very Good Book' }
    it { expect(book.author).to eq 'Pretty Good Writer' }
    it { expect(book.series).to eq nil }
    it { expect(book.is_audiobook).to eq false }
    it { expect(book.is_ebook).to eq false }
    it { expect(book.with_nat).to eq false }
    it { expect(book.label_ids).to eq []   }
    it { expect(book.list_id).to eq list[:id] }
  end

  describe '.create' do
    it { expect(Book.create(hash, json_book)).to be_a Book }

    it 'matches json attributes' do
      expect(Book.create(hash, json_book)).to convert_to(book)
    end

    it 'takes author from description if not in custom field' do
      json_book_no_custom_fields = json_book.merge({ customFieldItems: [] })
      expect(Book.create(hash, json_book_no_custom_fields))
        .to have_attributes( author: "Ghost Writer" )
    end

    it 'sets series to nil' do
      expect(Book.create(hash, json_book)).to have_attributes( series: nil )
    end

    it 'takes series from custom field' do
      json_book_in_series = json_book.merge({ customFieldItems: [{
        idCustomField: "sf_id",
        value: { text: 'The Adventures' },
      }]})
      expect(Book.create(hash, json_book_in_series))
        .to have_attributes( series: "The Adventures" )
    end

    it 'includes if I read the book with Nat' do
      json_book_with_nat = json_book.merge({ idLabels: [nat_label[:id]] })
      expect(Book.create(hash, json_book_with_nat))
        .to have_attributes( with_nat: true )
    end
  end

  describe '.create_all' do
    let(:hash_with_archived) { hash.merge({
      cards: [ json_book, { closed: "true" } ]
    })}

    it { expect(Book.create_all(hash_with_archived)).to all be_a Book }

    it 'ignores archived books' do
      expect(Book.create_all(hash_with_archived).size).to eq 1
    end
  end

  describe '#matches' do
    let(:dup_book)         { Book.new(title: book.title, author: book.author) }
    let(:different_title)  { Book.new(title: "Another", author: book.author) }
    let(:different_author) { Book.new(title: book.title, author: "Someone Else") }

    it { expect(book.matches(dup_book)).to be true }
    it { expect(book.matches(different_title)).to be false }
    it { expect(book.matches(different_author)).to be false }
  end

  describe '#to_s' do
    context 'when a physical book' do
      let(:pretty_book) { "**A Very Good Book** 📖\n*by Pretty Good Writer*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end

    context 'when in a series' do
      let(:book) {
        Book.new(
          title: 'A Very Good Book',
          author: 'Pretty Good Writer',
          series: 'Saga of Time',
          is_audiobook: true,
          list_id: list[:id],
        )
      }
      let(:pretty_book) {
        <<~BOOK
        **A Very Good Book** 🎧
        Series: Saga of Time
        *by Pretty Good Writer*

        BOOK
      }
      it { expect(book.to_s).to eq pretty_book }
    end

    context 'when an audiobook' do
      let(:book) {
        Book.new(
          title: 'A Very Good Book',
          author: 'Pretty Good Writer',
          is_audiobook: true,
          list_id: list[:id],
        )
      }
      let(:pretty_book) { "**A Very Good Book** 🎧\n*by Pretty Good Writer*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end

    context 'when an ebook' do
      let(:book) {
        Book.new(
          title: 'A Very Good Book',
          author: 'Pretty Good Writer',
          is_ebook: true,
          list_id: list[:id],
        )
      }
      let(:pretty_book) { "**A Very Good Book** 📱\n*by Pretty Good Writer*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end

    context 'when both audiobook and ebook' do
      let(:book) {
        Book.new(
          title: 'A Very Good Book',
          author: 'Pretty Good Writer',
          is_audiobook: true,
          is_ebook: true,
          list_id: list[:id],
        )
      }
      let(:pretty_book) { "**A Very Good Book** 📱🎧\n*by Pretty Good Writer*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end

    context 'when I read it with Natalie' do
      let(:book) {
        Book.new(
          title: 'A Very Good Book',
          author: 'Pretty Good Writer',
          with_nat: true,
          list_id: list[:id],
        )
      }
      let(:pretty_book) { "**A Very Good Book** 📖👩🏻‍🤝‍👩🏽\n*by Pretty Good Writer*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end
  end
end

RSpec::Matchers.define :convert_to do |expected|
  match do |actual|
    actual.title == expected.title &&
    actual.author == expected.author &&
    actual.series == expected.series &&
    actual.is_audiobook == expected.is_audiobook &&
    actual.is_ebook == expected.is_ebook &&
    actual.with_nat == expected.with_nat &&
    actual.label_ids == expected.label_ids &&
    actual.list_id == expected.list_id
  end
end
