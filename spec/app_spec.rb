require 'app'

# Note: This test requires a real csv file with dummy data
YEAR = '2021'
result = App.generate YEAR, "#{YEAR}/dummy.csv"

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
  end
end
