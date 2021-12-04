require 'app'

# Note: This test requires YEAR to point to a real directory with real data
YEAR = '2021'
summary = App.generate YEAR

describe App do
  describe '.generate' do
    it 'returns a Hash' do
      expect(summary).to be_a(Hash)
    end
    xit { expect(summary[:count]).to     eq(81) }
    xit { expect(summary[:fav]).to       eq(22) }
    # it { expect(summary[:dups]).to      eq("hello") }
    it { expect(summary[:nat]).to       eq(25) }
    it { expect(summary[:sleep]).to     eq(1) }
    # it { expect(summary[:audiobook]).to eq("hello") }
    # it { expect(summary[:ebook]).to     eq("hello") }
    # it { expect(summary[:physical]).to  eq("hello") }
    xit { expect(summary[:dnf]).to       eq(7) }
    xit { expect(summary[:current]).to   eq(3) }
  end
end
