require 'filter'
require 'models/book'

describe Filter do
  describe '.in_list' do
    list = { "id"=>"list_id", "name"=>"some_list" }
    another_list = { "id"=>"another_list_id", "name"=>"some_other_list" }

    book_in_list = Book.new('', '', false, false, [], list["id"], false)
    book_in_another_list = Book.new('', '', false, false, [], another_list["id"], false)
    closed_book_in_list = Book.new('', '', false, false, [], list["id"], true)

    books = [ book_in_list, book_in_another_list, closed_book_in_list ]

    it { expect(described_class.in_list(books, list)).to eq [book_in_list] }
    it { expect(described_class.in_list(books, another_list)).to eq [ book_in_another_list ] }
    context 'when the card is archived' do
      it { expect(described_class.in_list(books, list)).not_to include closed_book_in_list }
    end
  end

  describe 'label filters' do
    label = { "id"=>"label_id", "name"=>"some_label" }
    another_label = { "id"=>"another_label_id", "name"=>"some_other_label" }

    book_with_no_labels = Book.new('', '', false, false, [], '', false)
    book_with_label = Book.new('', '', false, false, [ label["id"] ], '', false)
    book_with_another_label = Book.new('', '', false, false, [ another_label["id"] ], '', false)
    book_with_both_labels = Book.new('', '', false, false, [ label["id"], another_label["id"] ], '', false)

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
      let(:json_book_with_label) {{ "idLabels"=>[ label["id"] ], "labels"=> [ label ] }}

      it { expect(described_class.has_json_label(json_book_with_label, label)).to be true }
      it { expect(described_class.has_json_label(json_book_with_label, another_label)).to be false }
    end
  end
end
