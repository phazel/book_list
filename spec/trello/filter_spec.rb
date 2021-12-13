# frozen_string_literal: true

require 'trello/filter'
require 'trello/models/book'

describe Filter do
  let(:book) { TrelloBook.new(title: '', author: '') }
  let(:book_fav) { book.is(:fav) }
  let(:book_dnf) { book.is(:dnf) }
  let(:book_fav_dnf) { book.is(:fav).is(:dnf) }

  let(:books) { [ book, book_fav, book_dnf, book_fav_dnf ] }

  let(:list) { { id: 'list_id', name: 'some_list' } }
  let(:another_list) { { id: 'another_list_id', name: 'some_other_list' } }
  let(:book_in_list) { book.with(list: list[:name]) }
  let(:book_in_another_list) { book.with(list: another_list[:name]) }

  describe '.in_list' do

    let(:books) { [ book_in_list, book_in_another_list ] }

    it { expect(described_class.in_list(books, list)).to eq [book_in_list] }
    it { expect(described_class.in_list(books, another_list)).to eq [ book_in_another_list ] }
  end

  describe '.by_list' do
    let(:book_in_list) { book.with(list: 'one') }
    let(:book_in_another_list) { book.with(list: 'two') }
    let(:book_in_irrelevant_list) { book.with(list: 'nah') }

    let(:books) { [ book_in_list, book_in_another_list, book_in_irrelevant_list ] }
    let(:list_names) { [ 'one', 'two', 'three' ] }
    let(:expected) { { one: [ book_in_list ], two: [ book_in_another_list ] } }
    it { expect(described_class.by_list(books, list_names)).to eq expected }
  end

  describe '.with' do
    it {
      expect(described_class.with(books, :fav))
        .to eq [book_fav, book_fav_dnf]
    }
    it {
      expect(described_class.with(books, :dnf))
        .to eq [book_dnf, book_fav_dnf]
    }
  end

  describe '.without' do
    context 'books with all labels' do
      it { expect(described_class.without(books, [])).to eq books }
    end
    context 'books without fav' do
      let(:expected) { [ book, book_dnf ] }
      it { expect(described_class.without(books, [:fav])).to eq expected }
    end
    context 'books without dnf' do
      let(:expected) { [ book, book_fav ] }
      it { expect(described_class.without(books, [:dnf])).to eq expected }
    end
    context 'books without either attribute' do
      let(:expected) { [ book ] }
      it { expect(described_class.without(books, %i[fav dnf])).to eq expected }
    end
  end

  describe '.by_series' do
    let(:book_no_series) { TrelloBook.new(title: '', author: '') }
    let(:book_series_a) { book.with(series: 'Big Series') }
    let(:book_series_b) { book.with(series: 'Another Series') }
    let(:books) { [ book_no_series, book_series_a, book_series_b ] }

    it 'groups books with and without a series' do
      expected = {
        'Big Series' => [ book_series_a ],
        'Another Series' => [ book_series_b ],
        no_series: [ book_no_series ]
      }
      expect(Filter.by_series(books)).to eq expected
    end
  end

  describe '.duplicates' do
    book1a = TrelloBook.new(title: '1', author: 'A')
    book1a_dup = book1a.is :ebook
    book1b = TrelloBook.new(title: '1', author: 'B')
    book1a_dup_dup = book1a.is :nat
    book2b = TrelloBook.new(title: '2', author: 'B')
    book2b_dup = book2b.is :ebook

    books = [ book1a, book1a_dup, book1b, book1a_dup_dup, book2b, book2b_dup ]
    expected = { dups: [ book1a, book2b ], non_dups: [ book1b ] }

    it { expect(described_class.duplicates(books)).to eq expected }
    it { expect(book1a.duplicates).to eq [ book1a_dup, book1a_dup_dup ] }
    it { expect(book1b.duplicates).to eq [] }
    it { expect(book2b.duplicates).to eq [ book2b_dup ] }
  end
end
