require 'books'

list = {
  "id"=>"list_id",
  "name"=>"some_list",
  "idBoard"=>"board_id"
}

another_list = {
  "id"=>"another_list_id",
  "name"=>"some_other_list",
  "idBoard"=>"board_id"
}

book_in_list = {
  "id"=>"book_in_list_id",
  "closed"=>false,
  "desc"=>"Author Name",
  "idBoard"=>"board_id",
  "idList"=>"list_id",
  "name"=>"Title Of This Book"
}

book_in_another_list = {
  "id"=>"book_in_list_id",
  "closed"=>false,
  "desc"=>"Author Name",
  "idBoard"=>"board_id",
  "idList"=>"another_list_id",
  "name"=>"Title Of This Book"
}

closed_book_in_list = {
  "id"=>"closed_book_id",
  "closed"=>true,
  "desc"=>"Author Name",
  "idBoard"=>"board_id",
  "idList"=>"list_id",
  "name"=>"Title Of This Book"
}

hash = {
  "lists" => [ list, another_list ],
  "cards" => [ book_in_list, book_in_another_list, closed_book_in_list ]
}

describe '.find' do
  it { expect(Books.find(hash, 'some_list')).to eq [ book_in_list ] }
  it { expect(Books.find(hash, 'some_other_list')).to eq [ book_in_another_list ] }
  
  context 'when the card is archived' do
    it { expect(Books.find(hash, 'some_list')).not_to include closed_book_in_list }
  end
end

describe '.find_list' do
  it { expect(Books.find_list(hash, 'some_list')).to eq list }
  it { expect(Books.find_list(hash, 'some_other_list')).to eq another_list }
  it { expect(Books.find_list(hash, 'does_not_exist')).to eq nil }
end
