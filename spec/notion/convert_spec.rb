require 'notion/convert'
include Convert

csv = <<~BOOKS
  Name,Author,Format
  Dune,Frank Herbert,audiobook
  Other Parties,C M Machado,"physical, read aloud"
BOOKS
dune = { title: 'Dune', author: 'Frank Herbert', format: ['audiobook'] }
other_parties = { title: 'Other Parties', author: 'C M Machado', format: ['physical', 'read aloud'] }
hashes = [dune, other_parties]

describe 'Convert' do
  describe '.split_strings' do
    it 'splits values for given keys into arrays with comma delimiter' do
      unsplit = { a: '1, 2', b: '3, 4', c: '5, 6, 7' }
      split = { a: '1, 2', b: ['3', '4'], c: ['5', '6', '7'] }
      expect(split_strings(unsplit, [:b, :c])).to eq(split)
    end
  end

  describe '.csv_to_array' do
    it { expect(csv_to_array(csv)).to be_an(Array) }
    it { expect(csv_to_array(csv)).to all(be_a(Hash)) }
    it 'contains hashes all with the required keys' do
      required_keys = [:title, :author, :format]
      expect(csv_to_array(csv).map(&:keys)).to all(include *required_keys)
    end
    it 'converts a csv string to an array of hashes' do
      expect(csv_to_array(csv)).to eq(hashes)
    end
  end

  describe '.array_to_books' do
    subject { array_to_books(hashes) }
    it { expect(subject).to be_an(Array) }
    it { expect(subject).to all(be_a(Book)) }
    it { expect(subject.length).to eq(hashes.length) }
  end

  describe '.hash_to_book' do
    context 'dune hash to book' do
      it { expect(hash_to_book(dune)).to be_a(Book) }
      it { expect(hash_to_book(dune)).to have_attributes(dune) }
    end
    context 'other_parties hash to book' do
      it { expect(hash_to_book(other_parties)).to be_a(Book) }
      it { expect(hash_to_book(other_parties)).to have_attributes(other_parties) }
    end
  end
end
