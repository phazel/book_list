# frozen_string_literal: true

require 'notion/filter'
require_relative '../support/test_data'
include Filter
include TestData

books = [ DUNE, WOLF_HALL, IF_FORTUNATE ]
expected = {
  current: [DUNE],
  done: [WOLF_HALL, IF_FORTUNATE],
}

describe 'Filter' do
  describe '.filter_by_status' do
    it { expect(filter_by_status(books)).to eq(expected) }
  end
end
