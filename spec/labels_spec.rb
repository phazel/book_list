require 'labels'

label = { "id"=>"l_id", "name"=>"some_label" }
another_label = { "id"=>"al_id", "name"=>"some_other_label" }

book_with_no_labels = { "idLabels"=>[], "labels"=> [] }
book_with_label = { "idLabels"=>[ label["id"] ], "labels"=> [ label ] }
book_with_another_label = {
  "idLabels"=>[ another_label["id"] ],
  "labels"=> [ another_label ]
}
book_with_both_labels = {
  "idLabels"=>[ label["id"], another_label["id"] ],
  "labels"=> [ label, another_label ]
}

books = [
  book_with_label,
  book_with_another_label,
  book_with_both_labels,
  book_with_no_labels
]

describe '.has_label' do
  it { expect(Labels.has_label(book_with_label, label)).to be true }
  it { expect(Labels.has_label(book_with_label, another_label)).to be false }
end

describe '.with_label' do
  it { expect(Labels.with_label(books, label)).to eq [book_with_label, book_with_both_labels] }
  it { expect(Labels.with_label(books, another_label)).to eq [book_with_another_label, book_with_both_labels] }
end

describe '.without_labels' do
  context 'books without label' do
    expected = [ book_with_another_label, book_with_no_labels ]
    it { expect(Labels.without_labels(books, [label])).to eq expected }
  end
  context 'books without another_label' do
    expected = [ book_with_label, book_with_no_labels ]
    it { expect(Labels.without_labels(books, [another_label])).to eq expected }
  end
  context 'books without both labels' do
    expected = [ book_with_no_labels ]
    it { expect(Labels.without_labels(books, [label, another_label])).to eq expected }
  end
  context 'books without no labels' do
    it { expect(Labels.without_labels(books, [])).to eq books }
  end
end

describe '.find' do
  hash = {
    "labels" => [label, another_label]
  }
  it { expect(Labels.find(hash, label['name'])).to eq label }
  it { expect(Labels.find(hash, another_label['name'])).to eq another_label }
  it { expect(Labels.find(hash, 'does_not_exist')).to eq nil }
end
