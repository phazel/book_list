require 'notion/convert'
include Convert

describe '.split_strings' do
  it 'splits values for given keys into arrays with comma delimiter' do
    hash = { a: '1, 2', b: '3, 4', c: '5, 6, 7' }
    expected_result = { a: '1, 2', b: ['3', '4'], c: ['5', '6', '7'] }
    expect(split_strings(hash, [:b, :c])).to eq(expected_result)
  end

  it 'converts a csv string to an array of hashes' do
    csv = <<~BOOKS
      Name,Author,Format
      Dune,Frank Herbert,audiobook
      Other Parties,C M Machado,"physical, read aloud"
    BOOKS
    expected_result = [
      { name: 'Dune', author: 'Frank Herbert', format: ['audiobook'] },
      { name: 'Other Parties', author: 'C M Machado', format: ['physical', 'read aloud'] },
    ]
    expect(csv_to_hash(csv)).to eq(expected_result)
  end
end
