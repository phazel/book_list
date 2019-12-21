require 'books'

list = { "id"=>"l_id", "name"=>"some_list" }
another_list = { "id"=>"al_id", "name"=>"some_other_list" }

book_in_list = { "idList"=>list["id"], "closed"=>false }
book_in_another_list = { "idList"=>another_list["id"], "closed"=>false }
closed_book_in_list = { "idList"=>list["id"], "closed"=>true }

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
