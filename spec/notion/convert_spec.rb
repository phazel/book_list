require 'notion/convert'
include Convert

csv = <<~BOOKS
  Name,Author,Format
  Dune,Frank Herbert,audiobook
  Other Parties,C M Machado,"physical, read aloud"
BOOKS
hashes = [
  { name: 'Dune', author: 'Frank Herbert', format: ['audiobook'] },
  { name: 'Other Parties', author: 'C M Machado', format: ['physical', 'read aloud'] },
]

describe 'Convert' do
  describe '.split_strings' do
    it 'splits values for given keys into arrays with comma delimiter' do
      unsplit = { a: '1, 2', b: '3, 4', c: '5, 6, 7' }
      split = { a: '1, 2', b: ['3', '4'], c: ['5', '6', '7'] }
      expect(split_strings(unsplit, [:b, :c])).to eq(split)
    end
  end

  describe '.csv_to_hash' do
    it { expect(csv_to_hash(csv)).to be_an(Array) }
    it { expect(csv_to_hash(csv)).to all(be_a(Hash)) }
    it 'contains hashes all with the required keys' do
      required_keys = [:name, :author, :format]
      expect(csv_to_hash(csv).map(&:keys)).to all(include *required_keys)
    end
    it 'converts a csv string to an array of hashes' do
      expect(csv_to_hash(csv)).to eq(hashes)
    end
  end

  describe '.hash_to_book' do
    it 'converts a hash to an array of books' do
      expect(hash_to_book(hashes[0])).to be_a(Book)
    end
  end
end
