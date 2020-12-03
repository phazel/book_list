require 'filter'
require 'models/book'

describe Filter do
  label = { id:"label_id", name:"some_label" }

  describe '.in_list' do
    list = { id:"list_id", name:"some_list" }
    another_list = { id:"another_list_id", name:"some_other_list" }

    book_in_list = Book.new('', '', false, false, [], list[:id])
    book_in_another_list = Book.new('', '', false, false, [], another_list[:id])

    books = [ book_in_list, book_in_another_list ]

    it { expect(described_class.in_list(books, list)).to eq [book_in_list] }
    it { expect(described_class.in_list(books, another_list)).to eq [ book_in_another_list ] }
  end

  describe 'label filters' do
    another_label = { id:"another_label_id", name:"some_other_label" }

    book_with_no_labels = Book.new('', '', false, false, [], '')
    book_with_label = Book.new('', '', false, false, [ label[:id] ], '')
    book_with_another_label = Book.new('', '', false, false, [ another_label[:id] ], '')
    book_with_both_labels = Book.new('', '', false, false, [ label[:id], another_label[:id] ], '')

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
    book1 = Book.new('Title 1', 'Author 1', true, false, [label[:id]], '')
    book2u = Book.new('Title 2', 'Author 2', false, false, [label[:id]], '')
    book1a = Book.new('Title 1', 'Author 1', false, true, [], '')
    book3 = Book.new('Title 3', 'Author 3', false, true, [], '')
    book1b = Book.new('Title 1', 'Author 1', false, true, [], '')
    book3a = Book.new('Title 3', 'Author 3', false, true, [], '')

    books = [ book1, book2u, book1a, book3, book1b, book3a ]

    it { expect(described_class.duplicates(books)).to eq [ book1, book3 ] }
  end
end
