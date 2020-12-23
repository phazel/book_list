# frozen_string_literal: true

require 'filter'
require 'models/book'

describe Filter do
  label = { id: 'label_id', name: 'some_label' }
  book = Book.new(title: '', author: '')

  describe '.in_list' do
    list = { id: 'list_id', name: 'some_list' }
    another_list = { id: 'another_list_id', name: 'some_other_list' }

    book_in_list = book.with_list_id(list[:id])
    book_in_another_list = book.with_list_id(another_list[:id])

    books = [ book_in_list, book_in_another_list ]

    it { expect(described_class.in_list(books, list)).to eq [book_in_list] }
    it { expect(described_class.in_list(books, another_list)).to eq [ book_in_another_list ] }
  end

  describe 'label filters' do
    another_label = { id: 'another_label_id', name: 'some_other_label' }

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
      it {
        expect(described_class.with_label(books, label))
          .to eq [book_with_label, book_with_both_labels]
      }
      it {
        expect(described_class.with_label(books, another_label))
          .to eq [book_with_another_label, book_with_both_labels]
      }
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

    describe '.label?' do
      it { expect(described_class.label?(book_with_label, label)).to be true }
      it { expect(described_class.label?(book_with_label, another_label)).to be false }
    end

    describe '.json_label?' do
      let(:json_book_with_label) { { idLabels: [ label[:id] ], labels: [ label ] } }

      it { expect(described_class.json_label?(json_book_with_label, label)).to be true }
      it { expect(described_class.json_label?(json_book_with_label, another_label)).to be false }
    end
  end

  describe '.duplicates' do
    book1a = Book.new(title: '1', author: 'A')
    book1a_dup = book1a.with_ebook
    book1b = Book.new(title: '1', author: 'B')
    book1a_dup_dup = book1a.with_nat
    book2b = Book.new(title: '2', author: 'B')
    book2b_dup = book2b.with_ebook

    books = [ book1a, book1a_dup, book1b, book1a_dup_dup, book2b, book2b_dup ]
    expected = { dups: [ book1a, book2b ], non_dups: [ book1b ] }

    it { expect(described_class.duplicates(books)).to eq expected }
    it { expect(book1a.duplicates).to eq [ book1a_dup, book1a_dup_dup ] }
    it { expect(book1b.duplicates).to eq [] }
    it { expect(book2b.duplicates).to eq [ book2b_dup ] }
  end

  describe '.dnf' do
    dnf_book = book.with_dnf
    books = [ book, dnf_book ]
    it { expect(described_class.dnf(books)).to eq [ dnf_book ] }
  end
end
