require 'labels'

label = {
  "id"=>"label_id",
  "idBoard"=>"board_id",
  "name"=>"some_label",
  "color"=>"some_colour"
}

another_label = {
  "id"=>"another_label_id",
  "idBoard"=>"board_id",
  "name"=>"some_other_label",
  "color"=>"another_colour"
}

book_with_label = {
  "id"=>"book_id",
  "closed"=>false,
  "desc"=>"Author Name",
  "idBoard"=>"board_id",
  "idLabels"=>[label["id"]],
  "idList"=>"list_id",
  "name"=>"Title Of This Book",
  "labels"=> [ label ]
}

book_with_another_label = {
  "id"=>"another_book_id",
  "closed"=>false,
  "desc"=>"Author Name",
  "idBoard"=>"board_id",
  "idLabels"=>[another_label["id"]],
  "idList"=>"list_id",
  "name"=>"Title Of This Book",
  "labels"=> [ another_label ]
}

book_with_both_labels = {
  "id"=>"book_with_both_labels_id",
  "closed"=>false,
  "desc"=>"Author Name",
  "idBoard"=>"board_id",
  "idLabels"=>[label["id"], another_label["id"]],
  "idList"=>"list_id",
  "name"=>"Title Of This Book",
  "labels"=> [ label, another_label ]
}

book_with_no_labels = {
  "id"=>"book_with_no_labels_id",
  "closed"=>false,
  "desc"=>"Author Name",
  "idBoard"=>"board_id",
  "idLabels"=>[],
  "idList"=>"list_id",
  "name"=>"Title Of This Book",
  "labels"=> []
}

books = [ book_with_label, book_with_another_label, book_with_both_labels, book_with_no_labels ]

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
  it { expect(Labels.find(hash, 'some_label')).to eq label }
  it { expect(Labels.find(hash, 'some_other_label')).to eq another_label }
  it { expect(Labels.find(hash, 'does_not_exist')).to eq nil }
end
