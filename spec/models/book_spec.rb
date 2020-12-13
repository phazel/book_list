require 'models/book'

describe Book do
  let(:list) {{ id: "list_id", name:"some_list" }}

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
    it { expect(book.is_audiobook).to eq false }
    it { expect(book.is_ebook).to eq false }
    it { expect(book.with_nat).to eq false }
    it { expect(book.label_ids).to eq []   }
    it { expect(book.list_id).to eq list[:id] }
  end

  describe '#to_s' do
    context 'when a physical book' do
      let(:pretty_book) { "**A Very Good Book** 📖\n*by Pretty Good Writer*\n\n" }
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

  describe '.create_all' do
    let(:field) {{ id: "f_id", name: "some_field" }}
    let(:another_field) {{ id: "af_id", name: "Author" }}
    let(:audio_label) {{ id: "a_id", name: "audiobook" }}
    let(:ebook_label) {{ id: "e_id", name: "ebook" }}
    let(:nat_label) {{ id: "n_id", name: "nat" }}
    let(:json_book) {{
      name: 'A Very Good Book',
      desc: "Blah blah blah",
      idLabels: [],
      idList: list[:id],
      customFieldItems: [{
        value: { text: 'Pretty Good Writer' },
        idCustomField: "af_id",
        }]
    }}
    let(:json_book_with_nat) { json_book.merge({
      name: "Good To Listen Together",
      idLabels: [nat_label[:id]],
      })}
    let(:json_book_no_custom_fields) { json_book.merge({
      name: "A Cynical Cash Grab 2",
      desc: "Ghost Writer",
      customFieldItems: [],
    })}
    let(:archived_json_book) {{ closed: "true" }}
    let(:hash) {{
      cards: [
        json_book,
        json_book_with_nat,
        archived_json_book,
        json_book_no_custom_fields,
      ],
      labels: [ audio_label, ebook_label, nat_label ],
      customFields: [ field, another_field ]
    }}

    it { expect(Book.create_all(hash)).to all be_a Book }

    it 'ignores archived books' do
      expect(Book.create_all(hash).size).to eq 3
    end

    it 'matches book attributes' do
      expect(Book.create_all(hash).first).to have_same_attributes_as(book)
    end

    it 'takes author from description if not in custom field' do
      expect(Book.create_all(hash).last).to have_attributes(
        title: "A Cynical Cash Grab 2",
        author: "Ghost Writer",
        is_audiobook: book.is_audiobook,
        is_ebook: book.is_ebook,
        label_ids: book.label_ids,
        list_id: book.list_id
      )
    end

    it 'includes if I read the book with Nat' do
      expect(Book.create_all(hash)[1]).to have_attributes(
        title: "Good To Listen Together",
        author: "Pretty Good Writer",
        is_audiobook: book.is_audiobook,
        is_ebook: book.is_ebook,
        label_ids: [nat_label[:id]],
        list_id: book.list_id,
        with_nat: true,
      )
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
end

RSpec::Matchers.define :have_same_attributes_as do |expected|
  match do |actual|
    actual.title == expected.title &&
    actual.author == expected.author &&
    actual.is_audiobook == expected.is_audiobook &&
    actual.is_ebook == expected.is_ebook &&
    actual.with_nat == expected.with_nat &&
    actual.label_ids == expected.label_ids &&
    actual.list_id == expected.list_id
  end
end
