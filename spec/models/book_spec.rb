# frozen_string_literal: true

require 'models/book'

describe Book do
  let(:list) { { id: 'list_id', name: 'some_list' } }
  let(:audio_label) { { id: 'a_id', name: 'audiobook' } }
  let(:ebook_label) { { id: 'e_id', name: 'ebook' } }
  let(:nat_label) { { id: 'n_id', name: 'nat' } }
  let(:sleep_label) { { id: 's_id', name: 'sleep' } }
  let(:author_field) { { id: 'af_id', name: 'Author' } }
  let(:series_field) { { id: 'sf_id', name: 'Series' } }
  let(:series_number_field) { { id: 'snf_id', name: 'Series Number' } }
  let(:json_book) do
    {
      name: 'A Very Good Book',
      desc: 'Ghost Writer',
      idLabels: [],
      idList: list[:id],
      customFieldItems: [{
        idCustomField: 'af_id',
        value: { text: 'Pretty Good Writer' }
      }]
    }
  end
  let(:hash) do
    {
      cards: [ json_book ],
      lists: [ list ],
      labels: [ audio_label, ebook_label, nat_label, sleep_label ],
      customFields: [ author_field, series_field, series_number_field ]
    }
  end
  let(:book) { Book.new(title: 'A Very Good Book', author: 'Pretty Good Writer') }

  describe '#initialize' do
    it { expect(book).to be_a Book }
    it { expect(book.title).to eq 'A Very Good Book' }
    it { expect(book.author).to eq 'Pretty Good Writer' }
    it { expect(book.series).to eq nil }
    it { expect(book.list).to eq nil }
    it { expect(book.audiobook).to eq false }
    it { expect(book.ebook).to eq false }
    it { expect(book.nat).to eq false }
    it { expect(book.sleep).to eq false }
    it { expect(book.dnf).to eq false }
    it { expect(book.fav).to eq false }
    it { expect { Book.new }.to raise_error(ArgumentError, 'missing keywords: title, author') }
  end

  describe '#matches' do
    let(:dup_book)         { book.dup }
    let(:different_title)  { book.with(title: 'Another') }
    let(:different_author) { book.with(author: 'Someone Else') }

    it { expect(book.matches(dup_book)).to be true }
    it { expect(book.matches(different_title)).to be false }
    it { expect(book.matches(different_author)).to be false }
  end

  describe '#with' do
    it { expect(book.with(series: 'Some Series').series).to eq 'Some Series' }
    it { expect { book.with(nope: 'Nup') }.to raise_error(ArgumentError, 'invalid attribute') }
  end

  describe '#is' do
    it { expect(book.is(:ebook).ebook).to eq true }
    it { expect { book.is(:nope) }.to raise_error(ArgumentError, 'invalid attribute') }
  end

  describe '#emojis' do
    it { expect(book.emojis).to eq '📖' }
    it { expect(book.is(:audiobook).emojis).to eq '🎧' }
    it { expect(book.is(:ebook).emojis).to eq '📱' }
    it { expect(book.is(:audiobook).is(:ebook).emojis).to eq '📱🎧' }
    it { expect(book.is(:nat).emojis).to eq '📖💞' }
    it { expect(book.is(:audiobook).is(:ebook).is(:nat).emojis).to eq '📱🎧💞' }
    it { expect(book.is(:sleep).emojis).to eq '📖🌒' }
    it { expect(book.is(:audiobook).is(:nat).is(:sleep).emojis).to eq '🎧💞🌒' }
  end

  describe '#to_s' do
    it { expect(book.to_s).to eq "**A Very Good Book** 📖\n*by Pretty Good Writer*\n\n" }

    context 'when in a series' do
      let(:book_in_series) { book.with(series: 'Saga of Time') }
      let(:pretty_book) do
        "**A Very Good Book** 📖\nSeries: Saga of Time\n*by Pretty Good Writer*\n\n"
      end
      it { expect(book_in_series.to_s).to eq pretty_book }

      context 'with a series number' do
        let(:book_in_series2) { book.with(series: 'Saga of Time', series_number: 2) }
        let(:pretty_book) do
          "**A Very Good Book** 📖\nSeries: Saga of Time, #2\n*by Pretty Good Writer*\n\n"
        end
        it { expect(book_in_series2.to_s).to eq pretty_book }
      end
    end
  end

  describe '.add_duplicate' do
    let(:book_with_dup) { book.dup.add_dup(book) }
    it { expect(book.duplicates).to eq [] }
    it { expect(book_with_dup.duplicates).to eq [ book ] }
  end
end
