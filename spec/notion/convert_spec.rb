require 'notion/convert'
include Convert

csv = <<~BOOKS
  Name,Author,Format,Status
  Dune,Frank Herbert,audiobook,📖 Reading 📖
  Wolf Hall,Hilary Mantel,audiobook,Read 2021
  Letters From a Stoic,Seneca,audiobook,Read 2021
  Her Body and Other Parties,Carmen Maria Machado,"physical, read aloud",📖 Reading 📖
  "To Be Taught, If Fortunate",Becky Chambers,"physical, read aloud",Read 2021
  We,Yevgeny Zamyatin,"audiobook, ebook, physical",To Read
  Shaping the Fractured Self: Poetry of Chronic Illness and Pain,Heather Taylor Johnson (Editor),physical,Paused
BOOKS
dune = { title: 'Dune', author: 'Frank Herbert', status: '📖 Reading 📖', format: ['audiobook'] }
wolf_hall = { title: 'Wolf Hall', author: 'Hilary Mantel', status: 'Read 2021', format: ['audiobook'] }
stoic = { title: 'Letters From a Stoic', author: 'Seneca', status: 'Read 2021', format: ['audiobook'] }
other_parties = { title: 'Her Body and Other Parties', author: 'Carmen Maria Machado', status: '📖 Reading 📖', format: ['physical', 'read aloud'] }
if_fortunate = { title: 'To Be Taught, If Fortunate', author: 'Becky Chambers', status: 'Read 2021', format: ['physical', 'read aloud'] }
we = { title: 'We', author: 'Yevgeny Zamyatin', status: 'To Read', format: ['audiobook', 'ebook', 'physical'] }
fractured_self = { title: 'Shaping the Fractured Self: Poetry of Chronic Illness and Pain', author: 'Heather Taylor Johnson (Editor)', status: 'Paused', format: ['physical'] }
hashes = [dune, wolf_hall, stoic, other_parties, if_fortunate, we, fractured_self]

describe 'Convert' do
  describe '.split_strings' do
    it 'splits values for given keys into arrays with comma delimiter' do
      unsplit = { a: '1, 2', b: '3, 4', c: '5, 6, 7' }
      split = { a: '1, 2', b: ['3', '4'], c: ['5', '6', '7'] }
      expect(split_strings(unsplit, [:b, :c])).to eq(split)
    end
  end

  describe '.csv_to_hashes' do
    it { expect(csv_to_hashes(csv)).to be_an(Array) }
    it { expect(csv_to_hashes(csv)).to all(be_a(Hash)) }
    it 'contains hashes all with the required keys' do
      required_keys = [:title, :author, :status, :format]
      expect(csv_to_hashes(csv).map(&:keys)).to all(include *required_keys)
    end
    it 'converts a csv string to an array of hashes' do
      expect(csv_to_hashes(csv)).to eq(hashes)
    end
  end

  describe '.hashes_to_books' do
    subject { hashes_to_books(hashes) }
    it { expect(subject).to be_an(Array) }
    it { expect(subject).to all(be_a(Book)) }
    it { expect(subject.length).to eq(hashes.length) }
  end

  describe '.csv_to_books' do
    subject { csv_to_books(csv) }
    it { expect(subject).to be_an(Array) }
    it { expect(subject).to all(be_a(Book)) }
  end

  describe '.hash_to_book' do
    context 'dune hash to book' do
      it { expect(hash_to_book(dune)).to be_a(Book) }
      it { expect(hash_to_book(dune)).to have_attributes(dune) }
    end
    context 'wolf_hall hash to book' do
      it { expect(hash_to_book(wolf_hall)).to be_a(Book) }
      it { expect(hash_to_book(wolf_hall)).to have_attributes(wolf_hall) }
    end
  end
end
