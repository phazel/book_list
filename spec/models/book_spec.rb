require 'models/book'

describe Book do
  let(:list) {{ id: "list_id", name:"some_list" }}
  let(:audio_label) {{ id: "a_id", name: "audiobook" }}
  let(:ebook_label) {{ id: "e_id", name: "ebook" }}
  let(:nat_label) {{ id: "n_id", name: "nat" }}
  let(:sleep_label) {{ id: "s_id", name: "sleep" }}
  let(:author_field) {{ id: "af_id", name: "Author" }}
  let(:series_field) {{ id: "sf_id", name: "Series" }}
  let(:series_number_field) {{ id: "snf_id", name: "Series Number" }}
  let(:json_book) {{
    name: 'A Very Good Book',
    desc: 'Ghost Writer',
    idLabels: [],
    idList: list[:id],
    customFieldItems: [{
      idCustomField: "af_id",
      value: { text: 'Pretty Good Writer' },
    }]
  }}
  let(:hash) {{
    cards: [ json_book ],
    lists: [ list ],
    labels: [ audio_label, ebook_label, nat_label, sleep_label ],
    customFields: [ author_field, series_field, series_number_field ]
  }}

  def make_book(options = {})
    Book.new(
      title: options[:title] ||= 'A Very Good Book',
      author: options[:author] ||= 'Pretty Good Writer')
        .with_series(options[:series] ||= nil)
        .with_series_number(options[:series_number] ||= nil)
        .with_label_ids(options[:label_ids] ||= [])
        .with_list_id(options[:list_id] ||= list[:id])
        .with_audiobook(options[:audiobook])
        .with_ebook(options[:ebook])
        .with_nat(options[:nat])
        .with_sleep(options[:sleep])
  end
  let(:book) { make_book() }

  describe '#initialize' do
    it { expect(book).to be_a Book }
    it { expect(book.title).to eq 'A Very Good Book' }
    it { expect(book.author).to eq 'Pretty Good Writer' }
    it { expect(book.series).to eq nil }
    it { expect(book.audiobook).to eq false }
    it { expect(book.ebook).to eq false }
    it { expect(book.nat).to eq false }
    it { expect(book.sleep).to eq false }
    it { expect(book.label_ids).to eq []   }
    it { expect(book.list_id).to eq list[:id] }
    it { expect{ Book.new }.to raise_error(ArgumentError, "missing keywords: title, author") }
  end

  describe '#matches' do
    let(:dup_book)         { make_book() }
    let(:different_title)  { make_book(title: "Another") }
    let(:different_author) { make_book(author: "Someone Else") }

    it { expect(book.matches(dup_book)).to be true }
    it { expect(book.matches(different_title)).to be false }
    it { expect(book.matches(different_author)).to be false }
  end

  describe '#emojis' do
    it{ expect(book.emojis)
      .to eq '📖' }
    it{ expect(make_book(audiobook: true).emojis)
      .to eq '🎧' }
    it{ expect(make_book(ebook: true).emojis)
      .to eq '📱' }
    it{ expect(make_book(audiobook: true, ebook: true).emojis)
      .to eq '📱🎧' }
    it{ expect(make_book(nat: true).emojis)
      .to eq '📖💞' }
    it{ expect(make_book(audiobook: true, ebook: true, nat: true).emojis)
      .to eq '📱🎧💞' }
    it{ expect(make_book(sleep: true).emojis)
      .to eq '📖🌒' }
    it{ expect(make_book(audiobook: true, nat: true, sleep: true).emojis)
      .to eq '🎧💞🌒' }
    end

  describe '#to_s' do
    it { expect(book.to_s).to eq "**A Very Good Book** 📖\n*by Pretty Good Writer*\n\n" }

    context 'when in a series' do
      let(:book_in_series) { make_book(series: 'Saga of Time') }
      let(:pretty_book) {
        "**A Very Good Book** 📖\nSeries: Saga of Time\n*by Pretty Good Writer*\n\n"
      }
      it { expect(book_in_series.to_s).to eq pretty_book }

      context 'with a series number' do
        let(:book_in_series_2) { make_book({ series: 'Saga of Time', series_number: 2 })}
        let(:pretty_book) {
          "**A Very Good Book** 📖\nSeries: Saga of Time, #2\n*by Pretty Good Writer*\n\n"
        }
        it { expect(book_in_series_2.to_s).to eq pretty_book }
      end
    end
  end
end
