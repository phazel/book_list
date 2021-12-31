# frozen_string_literal: true

require 'convert'
require_relative './support/test_data'
include Convert
include TestData

describe 'Convert' do
  describe '.split_strings' do
    it 'splits values for given keys into arrays of strings' do
      unsplit = { a: '1, 2', b: '3, 4', c: '5, 6, 7' }
      split = { a: '1, 2', b: ['3', '4'], c: ['5', '6', '7'] }
      expect(split_strings(unsplit, [:b, :c])).to eq(split)
    end
    it 'handles nil' do
      unsplit = { a: '1, 2', b: '3, 4'}
      split = { a: '1, 2', b: ['3', '4'] }
      expect(split_strings(unsplit, [:b, :absent])).to eq(split)
    end
  end

  describe '.split_strings_sym' do
    it 'splits values for given keys into arrays of symbols' do
      unsplit = { X: 'a, b', Y: 'c, d', Z: 'e, f, g' }
      split = { X: 'a, b', Y: [:c, :d], Z: [:e, :f, :g] }
      expect(split_strings_sym(unsplit, [:Y, :Z])).to eq(split)
    end
    it 'handles nil' do
      unsplit = { X: 'a, b', Y: 'c, d' }
      split = { X: 'a, b', Y: [:c, :d] }
      expect(split_strings_sym(unsplit, [:Y, :absent])).to eq(split)
    end
  end

  describe '.nil_to_empty' do
    it 'converts the given key from nil to empty arrays' do
      with_nil = { X: 'a, b', Y: [:c, :d] }
      with_empty = { X: 'a, b', Y: [:c, :d], absent: [] }
      expect(nil_to_empty(with_nil, :absent)).to eq(with_empty)
    end
  end

  describe '.fav_bool' do
    it { expect(fav_bool({fav: 'Yes'})).to eq({fav: true}) }
    it { expect(fav_bool({fav: 'yes'})).to eq({fav: true}) }
    it { expect(fav_bool({fav: 'YES'})).to eq({fav: true}) }
    it { expect(fav_bool({fav: 'No'})).to eq({fav: false}) }
    it { expect(fav_bool({fav: 'no'})).to eq({fav: false}) }
    it { expect(fav_bool({fav: 'NO'})).to eq({fav: false}) }
    it { expect(fav_bool({fav: 'something'})).to eq({fav: false}) }
    it { expect(fav_bool({})).to eq({fav: false}) }
  end

  describe '.csv_to_hashes' do
    it { expect(csv_to_hashes(CSV_DATA)).to be_an(Array) }
    it { expect(csv_to_hashes(CSV_DATA)).to all(be_a(Hash)) }
    it 'contains hashes all with the required keys' do
      required_keys = [:title, :author, :status, :formats]
      expect(csv_to_hashes(CSV_DATA).map(&:keys)).to all(include *required_keys)
    end
    it 'converts a csv string to an array of hashes' do
      expect(csv_to_hashes(CSV_DATA)).to eq(HASHES)
    end
  end

  describe '.hashes_to_books' do
    subject { hashes_to_books(HASHES) }
    it { expect(subject).to be_an(Array) }
    it { expect(subject).to all(be_a(Book)) }
    it { expect(subject.length).to eq(HASHES.length) }
  end

  describe '.csv_to_books' do
    subject { csv_to_books(CSV_DATA) }
    it { expect(subject).to be_an(Array) }
    it { expect(subject).to all(be_a(Book)) }
  end

  describe '.hash_to_book' do
    context 'Dune hash to book' do
      it { expect(hash_to_book(DUNE_HASH)).to be_a(Book) }
      it { expect(hash_to_book(DUNE_HASH)).to have_attributes(DUNE_HASH) }
    end
    context 'Wolf Hall hash to book' do
      it { expect(hash_to_book(WOLF_HALL_HASH)).to be_a(Book) }
      it { expect(hash_to_book(WOLF_HALL_HASH)).to have_attributes(WOLF_HALL_HASH) }
    end
  end
end
