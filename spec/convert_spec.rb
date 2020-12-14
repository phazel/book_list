require 'convert'

describe Convert do
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
    return Book.new(
      title: options[:title] ||= 'A Very Good Book',
      author: options[:author] ||= 'Pretty Good Writer',
      series: options[:series] ||= nil,
      series_number: options[:series_number] ||= nil,
      is_audiobook: options[:is_audiobook] ||= false,
      is_ebook: options[:is_ebook] ||= false,
      with_nat: options[:with_nat] ||= false,
      for_sleep: options[:for_sleep] ||= false,
      label_ids: options[:label_ids] ||= [],
      list_id: options[:list_id] ||= list[:id],
    )
  end
  let(:book) { make_book() }

  describe '.custom_field' do
    it { expect(Convert.custom_field(json_book, author_field, :text)).to eq 'Pretty Good Writer' }
    it { expect(Convert.custom_field(json_book, series_field, :number)).to eq nil }
    it { expect(Convert.custom_field(json_book, series_number_field, :number)).to eq nil }

    it 'finds the custom field' do
      json_sequel = json_book.merge({ customFieldItems: [{
        idCustomField: "snf_id",
        value: { number: 2 },
      }]})
      expect(Convert.custom_field(json_sequel, series_number_field, :number)).to eq 2
    end

    context 'the book has no author field' do
      let(:json_book_old) { json_book.merge({ customFieldItems: [] }) }

      it { expect(Convert.custom_field(json_book_old, author_field, :text)).to eq nil }
      it 'uses a default value' do
        expect(Convert.custom_field(json_book_old, author_field, :text, default: 'description text'))
          .to eq 'description text'
      end
    end
  end

  describe '.book' do
    it { expect(Convert.book(hash, json_book)).to be_a Book }

    it 'matches json attributes' do
      expect(Convert.book(hash, json_book)).to convert_to(book)
    end

    it 'takes author from description if not in custom field' do
      json_book_no_custom_fields = json_book.merge({ customFieldItems: [] })
      expect(Convert.book(hash, json_book_no_custom_fields))
        .to have_attributes( author: 'Ghost Writer' )
    end

    it 'sets series to nil' do
      expect(Convert.book(hash, json_book)).to have_attributes( series: nil )
    end

    context 'when the book is in a series' do
      let(:json_book_in_series) { json_book.merge({ customFieldItems: [{
        idCustomField: "sf_id",
        value: { text: 'The Adventures' },
      }]})}
      it 'sets the series' do
        expect(Convert.book(hash, json_book_in_series))
          .to have_attributes( series: "The Adventures" )
      end
      it { expect(Convert.book(hash, json_book_in_series))
          .to have_attributes( series_number: nil ) }

      it 'sets the series number if present' do
        json_book_in_series_w_num = json_book.merge({ customFieldItems:
          json_book_in_series[:customFieldItems] + [{
            idCustomField: "snf_id",
            value: { number: 2 },
        }]})
        expect(Convert.book(hash, json_book_in_series_w_num))
          .to have_attributes( series: "The Adventures", series_number: 2 )
      end
    end

    it 'includes if I read the book with Nat' do
      json_book_with_nat = json_book.merge({ idLabels: [nat_label[:id]] })
      expect(Convert.book(hash, json_book_with_nat))
        .to have_attributes( with_nat: true )
    end

    it 'includes if I read the book to sleep' do
      json_book_sleep = json_book.merge({ idLabels: [sleep_label[:id]] })
      expect(Convert.book(hash, json_book_sleep))
        .to have_attributes( for_sleep: true )
    end
  end

  describe '.all_books' do
    let(:hash_with_archived) { hash.merge({
      cards: [ json_book, { closed: "true" } ]
    })}

    it { expect(Convert.all_books(hash_with_archived)).to all be_a Book }

    it 'ignores archived books' do
      expect(Convert.all_books(hash_with_archived).size).to eq 1
    end
  end
end

RSpec::Matchers.define :convert_to do |expected|
  match do |actual|
    actual.title == expected.title &&
    actual.author == expected.author &&
    actual.series == expected.series &&
    actual.is_audiobook == expected.is_audiobook &&
    actual.is_ebook == expected.is_ebook &&
    actual.with_nat == expected.with_nat &&
    actual.label_ids == expected.label_ids &&
    actual.list_id == expected.list_id
  end
end
