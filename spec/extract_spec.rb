# frozen_string_literal: true

require 'extract'

describe Extract do
  let(:list) { { id: 'list_id', name: 'some_list' } }
  let(:some_other_list) { { id: 'al_id', name: 'some_other_list' } }
  let(:another_list) { { id: 'al_id', name: 'another_list' } }

  let(:audio_label) { { id: 'a_id', name: 'audiobook' } }
  let(:ebook_label) { { id: 'e_id', name: 'ebook' } }
  let(:nat_label) { { id: 'n_id', name: 'nat' } }
  let(:sleep_label) { { id: 's_id', name: 'sleep' } }
  let(:dnf_label) { { id: 'd_id', name: 'dnf' } }
  let(:fav_label) { { id: 'f_id', name: 'fav' } }

  let(:author_field) { { id: 'af_id', name: 'Author' } }
  let(:series_field) { { id: 'sf_id', name: 'Series' } }
  let(:series_number_field) { { id: 'snf_id', name: 'Series Number' } }

  let(:book) { make_book }
  let(:json_book) do
    {
      name: book.title,
      desc: 'Ghost Writer',
      idLabels: [],
      idList: list[:id],
      customFieldItems: [{
        idCustomField: author_field[:id],
        value: { text: book.author }
      }]
    }
  end
  let(:hash) do
    {
      cards: [ json_book ],
      lists: [ list, some_other_list, another_list ],
      labels: [ audio_label, ebook_label, nat_label, sleep_label, dnf_label, fav_label ],
      customFields: [ author_field, series_field, series_number_field ]
    }
  end

  describe '.list' do
    it { expect(Extract.list(hash, list[:name])).to eq list }
    it { expect(Extract.list(hash, 'does_not_exist')).to eq nil }
  end

  describe '.lists' do
    let(:lists) { [list[:name], another_list[:name]] }
    let(:expected) { { some_list: list, another_list: another_list } }

    it { expect(Extract.lists(hash, 3040, lists)).to eq expected }
    it { expect(Extract.lists(hash, 250, [])).to be_empty }
  end

  describe '.label' do
    it { expect(Extract.label(hash, ebook_label[:name])).to eq ebook_label }
    it { expect(Extract.label(hash, sleep_label[:name])).to eq sleep_label }
    it { expect(Extract.label(hash, 'does_not_exist')).to eq nil }
  end

  describe '.labels' do
    let(:labels) { [nat_label[:name], audio_label[:name]] }
    let(:expected) { { nat: nat_label, audiobook: audio_label } }

    it { expect(Extract.labels(hash, labels)).to eq expected }
    it { expect(Extract.labels(hash, [])).to be_empty }
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
    it { expect(Extract.book(hash, json_book)).to be_a Book }

    it 'matches json attributes' do
      expect(Extract.book(hash, json_book)).to convert_to(book)
    end

    it 'takes author from description if not in custom field' do
      json_book_no_custom_fields = json_book.merge({ customFieldItems: [] })
      expect(Extract.book(hash, json_book_no_custom_fields))
        .to have_attributes(author: 'Ghost Writer')
    end

    it 'sets series to nil' do
      expect(Extract.book(hash, json_book)).to have_attributes(series: nil)
    end

    context 'when the book is in a series' do
      let(:json_book_in_series) do
        items = [{ idCustomField: 'sf_id', value: { text: 'The Adventures' } }]
        json_book.merge({ customFieldItems: items })
      end
      it 'sets the series' do
        expect(Extract.book(hash, json_book_in_series))
          .to have_attributes(series: 'The Adventures')
      end
      it {
        expect(Extract.book(hash, json_book_in_series))
          .to have_attributes(series_number: nil)
      }

      it 'sets the series number if present' do
        items = [{ idCustomField: 'snf_id', value: { number: 2 } }]
        json_book_in_series_w_num = json_book.merge({ customFieldItems:
          json_book_in_series[:customFieldItems] + items })
        expect(Extract.book(hash, json_book_in_series_w_num))
          .to have_attributes(series: 'The Adventures', series_number: 2)
      end
    end

    it 'includes if I read the book with Nat' do
      json_book_with_nat = json_book.merge({ idLabels: [nat_label[:id]] })
      expect(Extract.book(hash, json_book_with_nat))
        .to have_attributes(nat: true)
    end

    it 'includes if I read the book to sleep' do
      json_book_sleep = json_book.merge({ idLabels: [sleep_label[:id]] })
      expect(Extract.book(hash, json_book_sleep))
        .to have_attributes(sleep: true)
    end

    it 'includes if I did not finish the book' do
      json_book_dnf = json_book.merge({ idLabels: [dnf_label[:id]] })
      expect(Extract.book(hash, json_book_dnf))
        .to have_attributes(dnf: true)
    end

    it 'includes if the book is a favourite' do
      json_book_fav = json_book.merge({ idLabels: [fav_label[:id]] })
      expect(Extract.book(hash, json_book_fav))
        .to have_attributes(fav: true)
    end
  end

  describe '.all_books' do
    let(:hash_with_archived) do
      hash.merge({ cards: hash[:cards] + [{ closed: 'true' }] })
    end

    it { expect(Extract.all_books(hash_with_archived)).to all be_a Book }

    it 'ignores archived books' do
      expect(Extract.all_books(hash_with_archived).size).to eq 1
    end
  end
end

def make_book(options = {})
  Book.new(
    title: options[:title] ||= 'A Very Good Book',
    author: options[:author] ||= 'Pretty Good Writer'
  ).with_series(options[:series] ||= nil)
      .with_series_number(options[:series_number] ||= nil)
      .with_label_ids(options[:label_ids] ||= [])
      .with_list_id(options[:list_id] ||= list[:id])
      .with_audiobook(cond: options[:audiobook])
      .with_ebook(cond: options[:ebook])
      .with_nat(cond: options[:nat])
      .with_sleep(cond: options[:sleep])
      .with_dnf(cond: options[:dnf])
      .with_fav(cond: options[:fav])
end

RSpec::Matchers.define :convert_to do |expected|
  match do |actual|
    actual.title == expected.title &&
      actual.author == expected.author &&
      actual.series == expected.series &&
      actual.series_number == expected.series_number &&
      actual.label_ids == expected.label_ids &&
      actual.list_id == expected.list_id &&
      actual.audiobook == expected.audiobook &&
      actual.ebook == expected.ebook &&
      actual.nat == expected.nat &&
      actual.sleep == expected.sleep &&
      actual.dnf == expected.dnf &&
      actual.fav == expected.fav
  end
end
