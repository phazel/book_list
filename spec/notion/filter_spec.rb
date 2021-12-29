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
end
