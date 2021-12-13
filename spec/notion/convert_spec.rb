require 'notion/convert'
include Convert

csv = <<~BOOKS
  Name,Author,Format
  Dune,Frank Herbert,audiobook
  Other Parties,C M Machado,"physical, read aloud"
BOOKS

describe 'Convert' do
  describe '.split_strings' do
    it 'splits values for given keys into arrays with comma delimiter' do
      hash = { a: '1, 2', b: '3, 4', c: '5, 6, 7' }
      expected_result = { a: '1, 2', b: ['3', '4'], c: ['5', '6', '7'] }
      expect(split_strings(hash, [:b, :c])).to eq(expected_result)
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
      expect(csv_to_hash(csv)).to eq([
        { name: 'Dune', author: 'Frank Herbert', format: ['audiobook'] },
        { name: 'Other Parties', author: 'C M Machado', format: ['physical', 'read aloud'] },
      ])
    end
  end
end
