# frozen_string_literal: true

require 'extract'

describe Extract do
  let(:year) { "4082" }
  let(:some_list) { { id: 'list_id', name: 'some_list' } }
  let(:unused_list) { { id: 'ul_id', name: 'unused_list' } }
  let(:another_list) { { id: 'al_id', name: 'another_list' } }
  let(:relevant_lists) { [ some_list, another_list ] }
  let(:relevant_list_names) { relevant_lists.map{|list| list[:name] } }

  let(:audio_label) { { id: 'a_id', name: 'audiobook' } }
  let(:ebook_label) { { id: 'e_id', name: 'ebook' } }
  let(:nat_label) { { id: 'n_id', name: 'nat' } }
  let(:sleep_label) { { id: 's_id', name: 'sleep' } }
  let(:dnf_label) { { id: 'd_id', name: 'dnf' } }
  let(:fav_label) { { id: 'f_id', name: 'fav' } }

  let(:author_field) { { id: 'af_id', name: 'Author' } }
  let(:series_field) { { id: 'sf_id', name: 'Series' } }
  let(:series_number_field) { { id: 'snf_id', name: 'Series Number' } }

  let(:book) do
    Book.new(title: 'A Very Good Book', author: 'Pretty Good Writer')
      .with(list: some_list[:name])
  end
  let(:json_book) do
    {
      name: book.title,
      desc: 'Ghost Writer',
      idLabels: [],
      idList: some_list[:id],
      customFieldItems: [{
        idCustomField: author_field[:id],
        value: { text: book.author }
      }]
    }
  end
  let(:another_json_book) { json_book.merge({ idList: another_list[:id] }) }
  let(:another_book) { book.with({ list: another_list[:name] }) }
  let(:hash) do
    {
      cards: [ json_book, another_json_book ],
      lists: [ some_list, unused_list, another_list ],
      labels: [ audio_label, ebook_label, nat_label, sleep_label, dnf_label, fav_label ],
      customFields: [ author_field, series_field, series_number_field ]
    }
  end

  describe '.list' do
    it { expect(Extract.list(hash, some_list[:name])).to eq some_list }
    it { expect(Extract.list(hash, 'does_not_exist')).to eq nil }
  end

  describe '.lists' do
    it { expect(Extract.lists(hash, year, relevant_list_names)).to eq relevant_lists }
    it { expect(Extract.lists(hash, year, [])).to be_empty }
  end

  describe '.label' do
    it { expect(Extract.label(hash, ebook_label[:name])).to eq ebook_label }
    it { expect(Extract.label(hash, sleep_label[:name])).to eq sleep_label }
    it { expect(Extract.label(hash, 'does_not_exist')).to eq nil }
  end

  describe '.custom_field' do
    it { expect(Extract.custom_field(hash, author_field[:name])).to eq author_field }
    it { expect(Extract.custom_field(hash, series_field[:name])).to eq series_field }
    it { expect(Extract.custom_field(hash, 'does_not_exist')).to eq nil }
  end

  describe '.book_custom_field' do
    it { expect(Extract.book_custom_field(json_book, author_field, :text)).to eq 'Pretty Good Writer' }
    it { expect(Extract.book_custom_field(json_book, series_field, :number)).to eq nil }
    it { expect(Extract.book_custom_field(json_book, series_number_field, :number)).to eq nil }

    it 'finds the custom field' do
      items = [{ idCustomField: 'snf_id', value: { number: 2 } }]
      json_sequel = json_book.merge({ customFieldItems: items })
      expect(Extract.book_custom_field(json_sequel, series_number_field, :number)).to eq 2
    end

    context 'the book has no author field' do
      let(:json_book_old) { json_book.merge({ customFieldItems: [] }) }

      it { expect(Extract.book_custom_field(json_book_old, author_field, :text)).to eq nil }
      it 'uses a default value' do
        expect(Extract.book_custom_field(json_book_old, author_field, :text, default: 'description text'))
          .to eq 'description text'
      end
    end
  end

  describe '.json_label?' do
    label = { id: 'label_id', name: 'some_label' }
    another_label = { id: 'another_label_id', name: 'some_other_label' }
    json_book_with_label = { idLabels: [ label[:id] ], labels: [ label ] }

    it { expect(described_class.json_label?(json_book_with_label, label)).to be true }
    it { expect(described_class.json_label?(json_book_with_label, another_label)).to be false }
  end

  describe '.book' do
    let(:extracted_book) { Extract.book(hash, json_book, relevant_lists) }
    it { expect(extracted_book).to be_a Book }
    it { expect(extracted_book.title).to eq book.title }
    it { expect(extracted_book.author).to eq book.author }
    it { expect(extracted_book.series).to eq nil }
    it { expect(extracted_book.series_number).to eq nil }
    it { expect(extracted_book.list).to eq book.list }
    it { expect(extracted_book.audiobook).to eq false }
    it { expect(extracted_book.ebook).to eq false }
    it { expect(extracted_book.nat).to eq false }
    it { expect(extracted_book.sleep).to eq false }
    it { expect(extracted_book.dnf).to eq false }
    it { expect(extracted_book.fav).to eq false }

    it 'takes author from description if not in custom field' do
      json_book_no_custom_fields = json_book.merge({ customFieldItems: [] })
      expect(Extract.book(hash, json_book_no_custom_fields, relevant_lists))
        .to have_attributes(author: 'Ghost Writer')
    end

    context 'when the book is in a series' do
      let(:json_book_in_series) do
        items = [{ idCustomField: 'sf_id', value: { text: 'The Adventures' } }]
        json_book.merge({ customFieldItems: items })
      end
      it 'sets the series' do
        expect(Extract.book(hash, json_book_in_series, relevant_lists))
          .to have_attributes(series: 'The Adventures')
      end
      it {
        expect(Extract.book(hash, json_book_in_series, relevant_lists))
          .to have_attributes(series_number: nil)
      }

      it 'sets the series number if present' do
        items = [{ idCustomField: 'snf_id', value: { number: 2 } }]
        json_book_in_series_w_num = json_book.merge({ customFieldItems:
          json_book_in_series[:customFieldItems] + items })
        expect(Extract.book(hash, json_book_in_series_w_num, relevant_lists))
          .to have_attributes(series: 'The Adventures', series_number: 2)
      end
    end

    it 'includes if I read the book with Nat' do
      json_book_with_nat = json_book.merge({ idLabels: [nat_label[:id]] })
      expect(Extract.book(hash, json_book_with_nat, relevant_lists))
        .to have_attributes(nat: true)
    end

    it 'includes if I read the book to sleep' do
      json_book_sleep = json_book.merge({ idLabels: [sleep_label[:id]] })
      expect(Extract.book(hash, json_book_sleep, relevant_lists))
        .to have_attributes(sleep: true)
    end

    it 'includes if I did not finish the book' do
      json_book_dnf = json_book.merge({ idLabels: [dnf_label[:id]] })
      expect(Extract.book(hash, json_book_dnf, relevant_lists))
        .to have_attributes(dnf: true)
    end

    it 'includes if the book is a favourite' do
      json_book_fav = json_book.merge({ idLabels: [fav_label[:id]] })
      expect(Extract.book(hash, json_book_fav, relevant_lists))
        .to have_attributes(fav: true)
    end
  end

  describe '.all_books' do
    let(:result) { Extract.all_books(hash, year, relevant_list_names) }

    it { expect(result).to be_a Hash }
    it { expect(result.size).to eq 2 }
    it { expect(result.keys).to eq [ :some_list, :another_list ] }
    it { expect(result[:some_list]).to all be_a Book }
    it { expect(result[:some_list].size).to eq 1 }
    it { expect(result[:another_list]).to all be_a Book }
    it { expect(result[:another_list].size).to eq 1 }

    describe 'books to ignore' do
      let(:hash_ignore) { hash.merge({ cards: hash[:cards] + [ ignore ] }) }

      context 'archived card' do
        let(:ignore) { { closed: 'true' } }
        it { expect(Extract.all_books(hash_ignore, year, relevant_list_names).size).to eq 2 }
      end

      context 'card in an irrelevant list' do
        let(:ignore) { json_book.merge({ idList: unused_list[:id] }) }
        it { expect(Extract.all_books(hash_ignore, year, relevant_list_names).size).to eq 2 }
      end
    end
  end
end
