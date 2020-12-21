require 'filter'
require 'models/book'

describe Filter do
  label = { id:"label_id", name:"some_label" }

  describe '.in_list' do
    list = { id:"list_id", name:"some_list" }
    another_list = { id:"another_list_id", name:"some_other_list" }

    book_in_list = Book.new(
      title: '',
      author: '',
      is_audiobook: false,
      is_ebook: false,
      with_nat: false,
      label_ids: [],
    ).with_list_id(list[:id])
    book_in_another_list = Book.new(
      title: '',
      author: '',
      is_audiobook: false,
      is_ebook: false,
      with_nat: false,
      label_ids: [],
    ).with_list_id(another_list[:id])

    books = [ book_in_list, book_in_another_list ]

    it { expect(described_class.in_list(books, list)).to eq [book_in_list] }
    it { expect(described_class.in_list(books, another_list)).to eq [ book_in_another_list ] }
  end

  describe 'label filters' do
    another_label = { id:"another_label_id", name:"some_other_label" }

    book_with_no_labels = Book.new(
      title: '',
      author: '',
      is_audiobook: false,
      is_ebook: false,
      with_nat: false,
      label_ids: [],
    )
    book_with_label = Book.new(
      title: '',
      author: '',
      is_audiobook: false,
      is_ebook: false,
      with_nat: false,
      label_ids: [ label[:id] ],
    )
    book_with_another_label = Book.new(
      title: '',
      author: '',
      is_audiobook: false,
      is_ebook: false,
      with_nat: false,
      label_ids: [ another_label[:id] ],
    )
    book_with_both_labels = Book.new(
      title: '',
      author: '',
      is_audiobook: false,
      is_ebook: false,
      with_nat: false,
      label_ids: [ label[:id], another_label[:id] ],
    )

    books = [
      book_with_label,
      book_with_another_label,
      book_with_both_labels,
      book_with_no_labels
    ]

    describe '.with_label' do
      it { expect(described_class.with_label(books, label)).to eq [book_with_label, book_with_both_labels] }
      it { expect(described_class.with_label(books, another_label)).to eq [book_with_another_label, book_with_both_labels] }
    end

    describe '.without_labels' do
      context 'books without label' do
        expected = [ book_with_another_label, book_with_no_labels ]
        it { expect(described_class.without_labels(books, [label])).to eq expected }
      end
      context 'books without another_label' do
        expected = [ book_with_label, book_with_no_labels ]
        it { expect(described_class.without_labels(books, [another_label])).to eq expected }
      end
      context 'books without both labels' do
        expected = [ book_with_no_labels ]
        it { expect(described_class.without_labels(books, [label, another_label])).to eq expected }
      end
      context 'books without no labels' do
        it { expect(described_class.without_labels(books, [])).to eq books }
      end
    end

    describe '.has_label' do
      it { expect(described_class.has_label(book_with_label, label)).to be true }
      it { expect(described_class.has_label(book_with_label, another_label)).to be false }
    end

    describe '.has_json_label' do
      let(:json_book_with_label) {{ idLabels:[ label[:id] ], labels: [ label ] }}

      it { expect(described_class.has_json_label(json_book_with_label, label)).to be true }
      it { expect(described_class.has_json_label(json_book_with_label, another_label)).to be false }
    end
  end

  describe '.duplicates' do
    book1 = Book.new(
      title: 'Title 1',
      author: 'Author 1',
      is_audiobook: true,
      is_ebook: false,
      with_nat: false,
      label_ids: [label[:id]],
    )
    book2u = Book.new(
      title: 'Title 2',
      author: 'Author 2',
      is_audiobook: false,
      is_ebook: false,
      with_nat: false,
      label_ids: [label[:id]],
    )
    book1a = Book.new(
      title: 'Title 1',
      author: 'Author 1',
      is_audiobook: false,
      is_ebook: true,
      with_nat: false,
      label_ids: [],
    )
    book3 = Book.new(
      title: 'Title 3',
      author: 'Author 3',
      is_audiobook: false,
      is_ebook: true,
      with_nat: false,
      label_ids: [],
    )
    book1b = Book.new(
      title: 'Title 1',
      author: 'Author 1',
      is_audiobook: false,
      is_ebook: true,
      with_nat: false,
      label_ids: [],
    )
    book3a = Book.new(
      title: 'Title 3',
      author: 'Author 3',
      is_audiobook: false,
      is_ebook: true,
      with_nat: false,
      label_ids: [],
    )

    books = [ book1, book2u, book1a, book3, book1b, book3a ]

    it { expect(described_class.duplicates(books)).to eq [ book1, book3 ] }
  end
end
