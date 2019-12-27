require 'format'

audiobook_label = { "id"=>"a_id", "name"=>"audiobook" }

book_with_no_labels = { "idLabels"=>[],
  "labels"=> [],
  "name"=>'book_1',
  "desc"=>'Author 1'
}
book_with_audiobook_label = {
  "idLabels"=>[ audiobook_label["id"] ],
  "labels"=> [ audiobook_label ],
  "name"=> 'book_2',
  "desc"=> 'Author 2'
}

hash = {
  'labels' => [ audiobook_label ],
  'cards' => [ book_with_no_labels, book_with_audiobook_label ]
}

book_not_audiobook = { "idLabels"=>[],
  "labels"=> [],
  "name"=>'book_1',
  "desc"=>'Author 1',
  "audiobook"=> false
}
book_is_audiobook = {
  "idLabels"=>[ audiobook_label["id"] ],
  "labels"=> [ audiobook_label ],
  "name"=> 'book_2',
  "desc"=> 'Author 2',
  "audiobook"=> true
}

books_with_audiobook_flag = [ book_not_audiobook, book_is_audiobook ]

books = [
  Book.new(book_not_audiobook['name'], book_not_audiobook['desc'], book_not_audiobook['audiobook']),
  Book.new(book_is_audiobook['name'], book_is_audiobook['desc'], book_is_audiobook['audiobook'])
]

pretty_books = [
  "**book_1**\n*by Author 1*\n\n",
  "**book_2** (Audiobook)\n*by Author 2*\n\n"
]


describe Format do
  describe '.header' do
    let(:year) { 3904 }
    let(:number) { 45 }
    let(:expected_header) {[ "# Books Read In 3904\n", "`Total books read: 45`\n\n" ]}
    it { expect(described_class.header(year, number)).to eq expected_header }
  end

  describe '.section' do
    let(:expected_section) {
      [ "---\n\n", "## Favourites:\n\n", pretty_books ]
    }
    it { expect(described_class.section(books_with_audiobook_flag, audiobook_label, :favourites)) }
  end

  describe '.pretty' do
    it { expect(described_class.pretty(books)).to eq pretty_books }
  end

  describe '.line' do
    it { expect(described_class.line).to eq [ "---\n\n" ] }
  end
end
