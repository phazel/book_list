require 'models/book'

describe Book do
  let(:title) { 'A Very Good Book' }
  let(:author) { 'Pretty Good Writer' }
  let(:is_audiobook) { false }
  let(:is_ebook) { false }
  let(:audio_label) {{ id: "a_id", name:"audiobook" }}
  let(:ebook_label) {{ id: "e_id", name:"ebook" }}
  let(:label_ids) do
    [
      is_audiobook ? audio_label["id"] : [],
      is_ebook ? ebook_label["id"] : []
    ].flatten
  end
  let(:list) {{ id: "list_id", name:"some_list" }}

  let(:book) do
    Book.new(title, author, is_audiobook, is_ebook, label_ids, list[:id])
  end

  describe '#initialize' do
    it { expect(book).to be_a Book }
    it { expect(book.title).to eq title }
    it { expect(book.author).to eq author }
    it { expect(book.is_audiobook).to eq is_audiobook }
    it { expect(book.is_ebook).to eq is_ebook }
    it { expect(book.label_ids).to eq label_ids }
    it { expect(book.list_id).to eq list[:id] }
  end

  describe '#to_s' do
    context 'when a physical book' do
      let(:pretty_book) { "**A Very Good Book** 📖\n*by Pretty Good Writer*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end

    context 'when an audiobook' do
      let(:is_audiobook) { true }
      let(:is_ebook) { false }
      let(:pretty_book) { "**A Very Good Book** 🎧\n*by Pretty Good Writer*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end

    context 'when an ebook' do
      let(:is_audiobook) { false }
      let(:is_ebook) { true }
      let(:pretty_book) { "**A Very Good Book** 📱\n*by Pretty Good Writer*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end

    context 'when both audiobook and ebook' do
      let(:is_audiobook) { true }
      let(:is_ebook) { true }
      let(:pretty_book) { "**A Very Good Book** 📱🎧\n*by Pretty Good Writer*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end
  end

  describe '.create_all' do
    let(:field) {{ id: "f_id", name: "some_field" }}
    let(:another_field) {{ id: "af_id", name: "Author" }}
    let(:json_book) {{
      name: title,
      desc: "Blah blah blah",
      idLabels: label_ids,
      idList: list[:id],
      customFieldItems: [{
        value: { text: 'Pretty Good Writer' },
        idCustomField: "af_id",
        }]
    }}
    let(:json_book_desc_author) {{
      name: "A Cynical Cash Grab",
      desc: "Ghost Writer",
      idLabels: label_ids,
      idList: list[:id],
      customFieldItems: []
    }}
    let(:json_book_no_custom_fields) {{
      name: "A Cynical Cash Grab",
      desc: "Ghost Writer",
      idLabels: label_ids,
      idList: list[:id],
    }}
    let(:archived_json_book) {{ closed: "true" }}
    let(:hash) {{
      cards: [
        json_book,
        json_book_desc_author,
        archived_json_book,
        json_book_no_custom_fields
      ],
      labels: [ audio_label, ebook_label ],
      customFields: [ field, another_field ]
    }}

    it { expect(Book.create_all(hash)).to all be_a Book }

    it 'ignores archived books' do
      expect(Book.create_all(hash).size).to eq 3
    end

    it 'matches book attributes' do
      expect(Book.create_all(hash).first).to have_attributes(
        title: book.title,
        author: book.author,
        is_audiobook: book.is_audiobook,
        is_ebook: book.is_ebook,
        label_ids: book.label_ids,
        list_id: book.list_id
      )
    end

    it 'takes author from description if not in custom field' do
      expect(Book.create_all(hash).last).to have_attributes(
        title: "A Cynical Cash Grab",
        author: "Ghost Writer",
        is_audiobook: book.is_audiobook,
        is_ebook: book.is_ebook,
        label_ids: book.label_ids,
        list_id: book.list_id
      )
    end
  end

  describe '#matches' do
    let(:dup_book) do
      Book.new(title, author, !is_audiobook, !is_ebook, [], '')
    end
    let(:different_book) do
      Book.new("Another", author, is_audiobook, is_ebook, label_ids, list[:id])
    end
    let(:different_author) do
      Book.new(title, "Someone Else", is_audiobook, is_ebook, label_ids, list[:id])
    end

    it { expect(book.matches(dup_book)).to be true }
    it { expect(book.matches(different_book)).to be false }
    it { expect(book.matches(different_author)).to be false }
  end
end
