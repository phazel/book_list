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
end
