require 'filter'
require 'models/book'

describe Filter do
  label = { id:"label_id", name:"some_label" }
  book = Book.new(title: '', author: '')

  describe '.in_list' do
    list = { id:"list_id", name:"some_list" }
    another_list = { id:"another_list_id", name:"some_other_list" }

    book_in_list = book.with_list_id(list[:id])
    book_in_another_list = book.with_list_id(another_list[:id])

    books = [ book_in_list, book_in_another_list ]

    it { expect(described_class.in_list(books, list)).to eq [book_in_list] }
    it { expect(described_class.in_list(books, another_list)).to eq [ book_in_another_list ] }
  end

  describe 'label filters' do
    another_label = { id:"another_label_id", name:"some_other_label" }

    book_with_label = book.with_label_ids([ label[:id] ])
    book_with_another_label = book.with_label_ids([ another_label[:id] ])
    book_with_both_labels = book.with_label_ids([ label[:id], another_label[:id] ])

    books = [
      book_with_label,
      book_with_another_label,
      book_with_both_labels,
      book
    ]

    describe '.with_label' do
      it { expect(described_class.with_label(books, label))
        .to eq [book_with_label, book_with_both_labels] }
      it { expect(described_class.with_label(books, another_label))
        .to eq [book_with_another_label, book_with_both_labels] }
    end

    describe '.without_labels' do
      context 'books without either label' do
        expected = [ book ]
        it { expect(described_class.without_labels(books, [label, another_label])).to eq expected }
      end
      context 'books without label' do
        expected = [ book_with_another_label, book ]
        it { expect(described_class.without_labels(books, [label])).to eq expected }
      end
      context 'books without another_label' do
        expected = [ book_with_label, book ]
        it { expect(described_class.without_labels(books, [another_label])).to eq expected }
      end
      context 'books with all labels' do
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
    book1A = Book.new(title: '1', author: 'A')
    book1A_dup = book1A.with_ebook
    book1B = Book.new(title: '1', author: 'B')
    book1A_dup_dup = book1A.with_nat
    book2B = Book.new(title: '2', author: 'B')
    book2B_dup = book2B.with_ebook

    books = [ book1A, book1A_dup, book1B, book1A_dup_dup, book2B, book2B_dup ]

    it { expect(described_class.duplicates(books)).to eq [ book1A, book2B ] }
  end
end
