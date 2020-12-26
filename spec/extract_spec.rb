# frozen_string_literal: true

require 'extract'

describe Extract do
  let(:year) { "4082" }
  let(:json_read_list) { { id: 'read_list_id', name: "Read #{year}" } }
  let(:json_current_list) { { id: 'current_list_id', name: '📖 Reading 📖' } }
  let(:unused_list) { { id: 'ul_id', name: 'unused_list' } }
  let(:read_list) { json_read_list.merge({ name: "read" }) }
  let(:current_list) { json_current_list.merge({ name: "current" }) }
  let(:all_lists) { [ read_list, current_list, unused_list ] }

  let(:audio_label) { { id: 'a_id', name: 'audiobook' } }
  let(:ebook_label) { { id: 'e_id', name: 'ebook' } }
  let(:nat_label) { { id: 'n_id', name: 'nat' } }
  let(:sleep_label) { { id: 's_id', name: 'sleep' } }
  let(:dnf_label) { { id: 'd_id', name: 'dnf' } }
  let(:fav_label) { { id: 'f_id', name: 'fav' } }

  let(:author_field) { { id: 'af_id', name: 'Author', type: 'text' } }
  let(:series_field) { { id: 'sf_id', name: 'Series', type: 'text' } }
  let(:series_number_field) { { id: 'snf_id', name: 'Series Number', type: 'number' } }

  let(:book) do
    Book.new(title: 'A Very Good Book', author: 'Pretty Good Writer')
      .with(list: 'read')
  end
  let(:minimal_json_book) do
    {
      idLabels: [],
      idList: read_list[:id],
    }
  end
  let(:json_book) do
    {
      name: book.title,
      desc: 'Ghost Writer',
      idLabels: [],
      idList: read_list[:id],
      customFieldItems: [{
        idCustomField: author_field[:id],
        value: { text: book.author }
      }]
    }
  end
  let(:another_json_book) { json_book.merge({ idList: current_list[:id] }) }
  let(:irrelevant_json_book) { json_book.merge({ idList: unused_list[:id] }) }
  let(:hash) do
    {
      cards: [ json_book, another_json_book, irrelevant_json_book ],
      lists: [ json_read_list, json_current_list, unused_list ],
      labels: [ audio_label, ebook_label, nat_label, sleep_label, dnf_label, fav_label ],
      customFields: [ author_field, series_field, series_number_field ]
    }
  end

  describe '.list' do
    let(:some_list) { { id: 'list_id', name: 'some_list' } }
    let(:another_list) { { id: 'al_id', name: 'another_list' } }
    let(:hash) { { lists: [ some_list, another_list ] } }
    it { expect(Extract.list(hash, some_list[:name])).to eq some_list }
    it { expect(Extract.list(hash, 'does_not_exist')).to eq nil }
  end

  describe '.lists' do
    let(:year) { "4082" }
    let(:hash) { { lists: [ json_read_list, json_current_list, unused_list ] } }
    it 'replaces names for read and current lists' do
      expect(Extract.lists(hash, year)).to eq all_lists
    end
  end

  describe '.label' do
    let(:hash) { { labels: [ audio_label, ebook_label, nat_label, sleep_label, dnf_label, fav_label ], } }
    it { expect(Extract.label(hash, ebook_label[:name])).to eq ebook_label }
    it { expect(Extract.label(hash, sleep_label[:name])).to eq sleep_label }
    it { expect(Extract.label(hash, 'does_not_exist')).to eq nil }
  end

  describe '.custom_field' do
    let(:author_field) { { id: 'af_id', name: 'Author', type: 'text' } }
    let(:series_field) { { id: 'sf_id', name: 'Series', type: 'text' } }
    let(:series_number_field) { { id: 'snf_id', name: 'Series Number', type: 'number' } }
    let(:hash) { { customFields: [ author_field, series_field, series_number_field ] } }

    it { expect(Extract.custom_field(hash, author_field[:name])[:type]).to eq :text }
    it { expect(Extract.custom_field(hash, series_field[:name])[:type]).to eq :text }
    it { expect(Extract.custom_field(hash, series_number_field[:name])[:type]).to eq :number }
    it { expect(Extract.custom_field(hash, 'does_not_exist')).to eq nil }
  end

  describe '.book_custom_field' do
    it_behaves_like "a non-empty custom field" do
      let(:field_type) { :text }
      let(:field_value) { 'A Series of Fine Adventures' }
    end
    it_behaves_like "a non-empty custom field" do
      let(:field_type) { :number }
      let(:field_value) { 5 }
    end
    it_behaves_like "an empty custom field" do
      let(:json_book) { { customFieldItems: [] } }
    end
    it_behaves_like "an empty custom field" do
      let(:json_book) { {} }
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
    subject { Extract.book(hash, json_book, all_lists) }
    it { expect(subject).to be_a Book }
    it { expect(subject.title).to eq book.title }
    it { expect(subject.author).to eq book.author }
    it { expect(subject.series).to eq nil }
    it { expect(subject.series_number).to eq nil }
    it { expect(subject.list).to eq book.list }
    it { expect(subject.audiobook).to eq false }
    it { expect(subject.ebook).to eq false }
    it { expect(subject.nat).to eq false }
    it { expect(subject.sleep).to eq false }
    it { expect(subject.dnf).to eq false }
    it { expect(subject.fav).to eq false }

    context 'the author is not in a custom field' do
      let(:json_book) do
        minimal_json_book.merge({ desc: 'Ghost Writer', customFieldItems: [] })
      end
      it { expect(subject).to have_attributes(author: 'Ghost Writer') }
    end

    context 'when the book is in a series' do
      let(:json_book_in_series) do
        items = [{ idCustomField: 'sf_id', value: { text: 'The Adventures' } }]
        json_book.merge({ customFieldItems: items })
      end
      it 'sets the series' do
        expect(Extract.book(hash, json_book_in_series, all_lists))
          .to have_attributes(series: 'The Adventures')
      end
      it {
        expect(Extract.book(hash, json_book_in_series, all_lists))
          .to have_attributes(series_number: nil)
      }

      it 'sets the series number if present' do
        items = [{ idCustomField: 'snf_id', value: { number: 2 } }]
        json_book_in_series_w_num = json_book.merge({ customFieldItems:
          json_book_in_series[:customFieldItems] + items })
        expect(Extract.book(hash, json_book_in_series_w_num, all_lists))
          .to have_attributes(series: 'The Adventures', series_number: 2)
      end
    end

    it 'includes if I read the book with Nat' do
      json_book_with_nat = json_book.merge({ idLabels: [nat_label[:id]] })
      expect(Extract.book(hash, json_book_with_nat, all_lists))
        .to have_attributes(nat: true)
    end

    it 'includes if I read the book to sleep' do
      json_book_sleep = json_book.merge({ idLabels: [sleep_label[:id]] })
      expect(Extract.book(hash, json_book_sleep, all_lists))
        .to have_attributes(sleep: true)
    end

    it 'includes if I did not finish the book' do
      json_book_dnf = json_book.merge({ idLabels: [dnf_label[:id]] })
      expect(Extract.book(hash, json_book_dnf, all_lists))
        .to have_attributes(dnf: true)
    end

    it 'includes if the book is a favourite' do
      json_book_fav = json_book.merge({ idLabels: [fav_label[:id]] })
      expect(Extract.book(hash, json_book_fav, all_lists))
        .to have_attributes(fav: true)
    end
  end

  describe '.all_books' do
    let(:hash_archived) { hash.merge({ cards: hash[:cards] + [{ closed: 'true' }] }) }
    let(:num_expected_books) { 3 }

    subject(:value) { Extract.all_books(hash_archived, year) }
    it { expect(value).to all be_a Book }

    it 'does not include archived cards' do
      expect(value.size).to eq num_expected_books
    end
  end
end
