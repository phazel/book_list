require 'convert'

label = {
  "id"=>"label_id",
  "idBoard"=>"board_id",
  "name"=>"some_label",
  "color"=>"some_colour"
}

another_label = {
  "id"=>"another_label",
  "idBoard"=>"board_id",
  "name"=>"some_label",
  "color"=>"purple"
}

book = {
  "id"=>"book_id",
  "closed"=>false,
  "desc"=>"Author Name",
  "idBoard"=>"board_id",
  "idLabels"=>[label["id"], another_label["id"]],
  "idList"=>"list_id",
  "name"=>"Title Of This Book",
  "labels"=> [ label, another_label ]
}

describe 'has_label' do
  context 'when the book has the label' do
    it 'returns true' do
      has_label(book, label)
    end
  end
end
