require 'models/book'

describe Book do
  let(:title) { 'A Very Good Book' }
  let(:author) { 'Pretty Good Writer' }
  let(:is_audiobook) { false }
  let(:is_ebook) { false }
  let(:audio_label) {{ id: "a_id", name: "audiobook" }}
  let(:ebook_label) {{ id: "e_id", name: "ebook" }}
  let(:label_ids) do
    [
      is_audiobook ? audio_label[:id] : [],
      is_ebook ? ebook_label[:id] : [],
    ].flatten
  end
  let(:list) {{ id: "list_id", name:"some_list" }}
  let(:with_nat) { false }

  let(:book) do
    Book.new(
      title: title,
      author: author,
      is_audiobook: is_audiobook,
      is_ebook: is_ebook,
      with_nat: with_nat,
      label_ids: label_ids,
      list_id: list[:id]
    )
  end

  describe '#initialize' do
    it { expect(book).to be_a Book }
    it { expect(book.title).to eq title }
    it { expect(book.author).to eq author }
    it { expect(book.is_audiobook).to eq is_audiobook }
    it { expect(book.is_ebook).to eq is_ebook }
    it { expect(book.with_nat).to eq with_nat }
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

    context 'when I read it with Natalie' do
      let(:with_nat) { true }
      let(:pretty_book) { "**A Very Good Book** 📖👩🏻‍🤝‍👩🏽\n*by Pretty Good Writer*\n\n" }
      it { expect(book.to_s).to eq pretty_book }
    end
  end

  describe '.create_all' do
    let(:field) {{ id: "f_id", name: "some_field" }}
    let(:another_field) {{ id: "af_id", name: "Author" }}
    let(:nat_label) {{ id: "n_id", name: "nat" }}
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
    let(:json_book_with_nat) {{
      name: "Good To Listen Together",
      desc: "Someone Cool",
      idLabels: label_ids + [nat_label[:id]],
      idList: list[:id],
      }}
    let(:json_book_no_custom_fields) {{
      name: "A Cynical Cash Grab 2",
      desc: "Ghost Writer",
      idLabels: label_ids,
      idList: list[:id],
    }}
    let(:archived_json_book) {{ closed: "true" }}
    let(:hash) {{
      cards: [
        json_book,
        json_book_desc_author,
        json_book_with_nat,
        archived_json_book,
        json_book_no_custom_fields,
      ],
      labels: [ audio_label, ebook_label, nat_label ],
      customFields: [ field, another_field ]
    }}

    it { expect(Book.create_all(hash)).to all be_a Book }

    it 'ignores archived books' do
      expect(Book.create_all(hash).size).to eq 4
    end

    it 'matches book attributes' do
      expect(Book.create_all(hash).first).to have_attributes(
        title: book.title,
        author: book.author,
        is_audiobook: book.is_audiobook,
        is_ebook: book.is_ebook,
        label_ids: book.label_ids,
        list_id: book.list_id,
        with_nat: book.with_nat
      )
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
      expect(Book.create_all(hash)[2]).to have_attributes(
        title: "Good To Listen Together",
        author: "Someone Cool",
        is_audiobook: book.is_audiobook,
        is_ebook: book.is_ebook,
        label_ids: [nat_label[:id]],
        list_id: book.list_id,
        with_nat: true,
      )
    end
  end

  describe '#matches' do
    let(:dup_book) do
      Book.new(
        title: title,
        author: author,
        is_audiobook: !is_audiobook,
        is_ebook: !is_ebook,
        with_nat: with_nat,
        label_ids: [],
        list_id: ''
      )
    end
    let(:different_title) do
      Book.new(
        title: "Another",
        author: author,
        is_audiobook: is_audiobook,
        is_ebook: is_ebook,
        with_nat: with_nat,
        label_ids: label_ids,
        list_id: list[:id]
      )
    end
    let(:different_author) do
      Book.new(
        title: title,
        author: "Someone Else",
        is_audiobook: is_audiobook,
        is_ebook: is_ebook,
        with_nat: with_nat,
        label_ids: label_ids,
        list_id: list[:id]
      )
    end

    it { expect(book.matches(dup_book)).to be true }
    it { expect(book.matches(different_title)).to be false }
    it { expect(book.matches(different_author)).to be false }
  end
end
