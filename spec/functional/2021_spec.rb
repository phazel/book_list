require 'app'

# Note: This test requires a real csv file with dummy data
YEAR = '2021'
result = App.convert YEAR, "#{YEAR}/dummy.csv"

describe App do
  describe '.convert' do
    it 'is an array' do
      expect(result).to be_an(Array)
    end
    it 'is a collection of hashes' do
      expect(result).to all(be_a(Hash))
    end
    it 'contains hashes all with the required keys' do
      required_keys = [:name, :author, :format]
      expect(result.map(&:keys)).to all(include *required_keys)
    end

    it 'converts a csv file to an array of hashes' do
      expected_result = [
        { name: 'Dune', author: 'Frank Herbert', format: ['audiobook'] },
        { name: 'Other Parties', author: 'C M Machado', format: ['physical', 'read aloud'] },
      ]
      expect(result).to eq(expected_result)
    end
  end

  describe '.split_strings' do
    it 'splits values for given keys into arrays with comma delimiter' do
      hash = { a: '1, 2', b: '3, 4', c: '5, 6, 7' }
      keys = [:b, :c]
      expected_result = { a: '1, 2', b: ['3', '4'], c: ['5', '6', '7'] }
      expect(App.split_strings(hash, keys)).to eq(expected_result)
    end
  end
end
