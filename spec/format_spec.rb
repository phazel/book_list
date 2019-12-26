require 'format'

audiobook_label = { "id"=>"a_id", "name"=>"audiobook" }

book_with_no_labels = { "idLabels"=>[], "labels"=> [] }
book_with_audiobook_label = { "idLabels"=>[ audiobook_label["id"] ], "labels"=> [ audiobook_label ] }

hash = {
  'labels' => [ audiobook_label ],
  'cards' => [ book_with_no_labels, book_with_audiobook_label ]
}

book_not_audiobook = { "idLabels"=>[], "labels"=> [], "audiobook"=> false }
book_is_audiobook = {
  "idLabels"=>[ audiobook_label["id"] ],
  "labels"=> [ audiobook_label ],
  "audiobook"=> true
}

books_with_audiobook_flag = [ book_not_audiobook, book_is_audiobook ]

describe Format do
  describe '.add_audiobook' do
    it { expect(described_class.add_audiobook(hash, audiobook_label)).to eq books_with_audiobook_flag }
  end
end
