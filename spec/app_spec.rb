# frozen_string_literal: true

require 'app'

# Note: This test requires a real csv file with dummy data
books = App.get_books "2021/dummy.csv"
summary = App.summary(books)

describe App do
  describe '.convert' do
    it 'returns a Hash' do
      expect(summary).to be_a(Hash)
    end
    it { expect(summary[:total]).to         eq(11) }
    it { expect(summary[:total_deduped]).to eq(10) }

    it { expect(summary[:done]).to          eq(5) }
    it { expect(summary[:current]).to       eq(3) }

    it { expect(summary[:audiobook]).to     eq(4) }
    it { expect(summary[:ebook]).to         eq(2) }
    it { expect(summary[:physical]).to      eq(1) }

    it { expect(summary[:dups]).to          eq(1) }
    it { expect(summary[:fav]).to           eq(3) }
    it { expect(summary[:nat]).to           eq(2) }
    it { expect(summary[:sleep]).to         eq(1) }
    it { expect(summary[:reread]).to         eq(2) }
    # it { expect(summary[:dnf]).to           eq("?") }
    # it { expect(summary[:series]).to           eq("?") }
    # it { expect(summary[:read_aloud]).to           eq("?") }
  end
end
