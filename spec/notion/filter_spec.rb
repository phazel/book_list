# frozen_string_literal: true

require 'notion/filter'
require_relative '../support/test_data'
include Filter
include TestData

books = [ DUNE, WOLF_HALL, IF_FORTUNATE ]

describe 'Filter' do
  describe '.filter_by_status' do
    by_status = {
      current: [DUNE],
      done: [WOLF_HALL, IF_FORTUNATE],
    }
    it { expect(filter_by_status(books)).to eq(by_status) }
  end

  describe '.filter_by_format' do
    by_format = {
      audiobook: [DUNE, WOLF_HALL],
      physical: [IF_FORTUNATE],
      read_aloud: [IF_FORTUNATE],
    }
    it { expect(filter_by_format(books)).to eq(by_format) }
  end

  describe '.filter_by_fav' do
    by_fav = { fav: [DUNE, WOLF_HALL], non_fav: [IF_FORTUNATE] }
    it { expect(filter_by_fav(books)).to eq(by_fav) }
  end

  describe '.dup?' do
    it { expect(dup?(WE, WE_DUP)).to eq(true) }
    it { expect(dup?(WE, WE)).to eq(false) }
  end

  describe '.filter_by_dups' do
    it 'groups duplicates into their own arrays' do
      books_dups = books + [ WE_DUP, DUNE_DUP_1, DUNE_DUP_2, WE ]
      by_dups = {
        dups: [[DUNE, DUNE_DUP_1, DUNE_DUP_2], [WE_DUP, WE]],
        non_dups: [WOLF_HALL, IF_FORTUNATE],
      }
      expect(filter_by_dups(books_dups)).to eq(by_dups)
    end
  end

  describe '.dedupe_status' do
    it { expect(dedupe_status('done', 'To Read')).to eq('done') }
    it { expect(dedupe_status('current', 'To Read')).to eq('current') }
    it { expect(dedupe_status('done', 'current')).to eq('done') }
    it { expect(dedupe_status('To Read', 'done')).to eq('done') }
    it { expect(dedupe_status('To Read', 'current')).to eq('current') }
    it { expect(dedupe_status('current', 'done')).to eq('done') }
    it { expect(dedupe_status('To Read', 'something')).to eq('To Read') }
    it { expect(dedupe_status('something', 'To Read')).to eq('something') }
  end

  describe '.dedupe_formats' do
    it { expect(dedupe_formats(['1','2','3'], ['2','4'])).to eq(['1','2','3','4']) }
  end

  describe '.dedupe_fav' do
    it { expect(dedupe_fav(false, false)).to eq(false) }
    it { expect(dedupe_fav(true, true)).to eq(true) }
    it { expect(dedupe_fav(true, false)).to eq(true) }
    it { expect(dedupe_fav(false, true)).to eq(true) }
  end

  describe '.dedupe_book' do
    it { expect(dedupe_book(WE, WE_DUP)).to be_a Book }
    it 'throws error if books are not duplicates' do
      expect{ dedupe_book(WE, DUNE) }.to raise_error(StandardError, /Books must be duplicates/)
    end
    it 'has correct attributes' do
      expect(dedupe_book(WE, WE_DUP)).to have_attributes(
        title: WE.title,
        author: WE.author,
        status: 'done',
        formats: ['audiobook', 'ebook', 'physical', 'read aloud' ]
      )
    end
  end

  describe '.dedupe_group' do
    group = [DUNE, DUNE_DUP_1, DUNE_DUP_2]
    it { expect(dedupe_group(group)).to be_a Book }
    it 'has correct attributes' do
      expect(dedupe_group(group)).to have_attributes(
        title: DUNE.title,
        author: DUNE.author,
        status: 'done',
        formats: ['audiobook', 'ebook', 'physical']
      )
    end
  end

  describe '.dedup' do
    books_dups = books + [ WE_DUP, DUNE_DUP_1, DUNE_DUP_2, WE ]
    deduped = {
      dups: [[DUNE, DUNE_DUP_1, DUNE_DUP_2], [WE_DUP, WE]],
      non_dups: [WOLF_HALL, IF_FORTUNATE],
    }
    subject { dedup(books_dups) }
    it { expect(subject[:dups]).to all be_a Book }
    it { expect(subject[:dups].size).to eq(2)}
    it { expect(subject[:non_dups]).to eq([WOLF_HALL, IF_FORTUNATE]) }
    it 'creates composite Dune book' do
      expect(subject[:dups][0]).to have_attributes(
        title: DUNE.title,
        author: DUNE.author,
        status: 'done',
        formats: ['audiobook', 'ebook', 'physical']
      )
    end
    it 'creates composite We book' do
      expect(subject[:dups][1]).to have_attributes(
        title: WE.title,
        author: WE.author,
        status: 'done',
        formats: ['audiobook', 'ebook', 'read aloud', 'physical']
      )
    end
  end
end
