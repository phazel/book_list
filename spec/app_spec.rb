# frozen_string_literal: true

require 'app'

YEAR = '2021'
# Note: This test requires a real csv file with dummy data
books = App.get_books "#{YEAR}/dummy.csv", YEAR
summary = App.summary(books)

describe App do
  describe '.convert' do
    it { expect(summary).to be_a(Hash) }

    it { expect(summary[:total]).to         eq(11) }
    it { expect(summary[:total_deduped]).to eq(10) }

    it { expect(summary[:done]).to          eq(5) }
    it { expect(summary[:current]).to       eq(3) }

    it { expect(summary[:audiobook]).to     eq(3) }
    it { expect(summary[:ebook]).to         eq(2) }
    it { expect(summary[:physical]).to      eq(1) }
    it { expect(summary[:read_aloud]).to    eq(2) }

    it { expect(summary[:dups]).to          eq(1) }
    it { expect(summary[:fav]).to           eq(3) }
    it { expect(summary[:nat]).to           eq(2) }
    it { expect(summary[:sleep]).to         eq(1) }
    it { expect(summary[:reread]).to         eq(2) }
    it { expect(summary[:dnf]).to           eq(1) }
    # it { expect(summary[:series]).to           eq("?") }
  end
end
