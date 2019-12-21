require 'find'

list = { "id"=>"l_id", "name"=>"some_list" }
another_list = { "id"=>"al_id", "name"=>"some_other_list" }

book_in_list = { "idList"=>list["id"], "closed"=>false }
book_in_another_list = { "idList"=>another_list["id"], "closed"=>false }

label = { "id"=>"l_id", "name"=>"some_label" }
another_label = { "id"=>"al_id", "name"=>"some_other_label" }

hash = {
  "lists" => [ list, another_list ],
  "cards" => [ book_in_list, book_in_another_list ],
  "labels" => [label, another_label]
}

describe Find do
  describe '.books_in_list' do
    it { expect(described_class.books_in_list(hash, list['name'])).to eq [ book_in_list ] }
    it { expect(described_class.books_in_list(hash, another_list['name'])).to eq [ book_in_another_list ] }
  end

  describe '.list' do
    it { expect(described_class.list(hash, list['name'])).to eq list }
    it { expect(described_class.list(hash, another_list['name'])).to eq another_list }
    it { expect(described_class.list(hash, 'does_not_exist')).to eq nil }
  end

  describe '.label' do
    it { expect(described_class.label(hash, label['name'])).to eq label }
    it { expect(described_class.label(hash, another_label['name'])).to eq another_label }
    it { expect(described_class.label(hash, 'does_not_exist')).to eq nil }
  end
end
