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
      expect(result).to all(be_a(Book))
    end
  end
end
