# frozen_string_literal: true

require 'extract'
require 'support/shared_examples'

describe Extract do
  let(:year) { "4082" }
  let(:json_read_list) { { id: 'read_list_id', name: "Read #{year}" } }
  let(:json_current_list) { { id: 'current_list_id', name: '📖 Reading 📖' } }
  let(:unused_list) { { id: 'ul_id', name: 'unused_list' } }
  let(:read_list) { json_read_list.merge({ name: "read" }) }
  let(:current_list) { json_current_list.merge({ name: "current" }) }
  let(:all_lists) { [ read_list, current_list, unused_list ] }

  let(:audiobook_label) { { id: 'a_id', name: 'audiobook' } }
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
  let(:jb) { minimal_json_book.merge(jb_additions) }
  let(:json_book) do
    minimal_json_book.merge({
      name: book.title,
      desc: 'Ghost Writer',
      customFieldItems: [{
        idCustomField: author_field[:id],
        value: { text: book.author }
      }]
    })
  end
  let(:another_json_book) { minimal_json_book.merge({ idList: current_list[:id] }) }
  let(:irrelevant_json_book) { minimal_json_book.merge({ idList: unused_list[:id] }) }
  let(:hash) do
    {
      cards: [ json_book, another_json_book, irrelevant_json_book ],
      lists: [ json_read_list, json_current_list, unused_list ],
      labels: [ audiobook_label, ebook_label, nat_label, sleep_label, dnf_label, fav_label ],
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
    let(:hash) { { labels: [ audiobook_label, ebook_label, nat_label, sleep_label, dnf_label, fav_label ], } }
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
      let(:jb_additions) { { customFieldItems: [] } }
    end
    it_behaves_like "an empty custom field" do
      let(:jb_additions) { {} }
    end
  end

  describe '.json_label?' do
    let(:label) { { id: 'label_id', name: 'some_label' } }
    let(:another_label) { { id: 'another_label_id', name: 'some_other_label' } }
    let(:jb_additions) { { idLabels: [ label[:id] ], labels: [ label ] } }

    it { expect(described_class.json_label?(jb, label)).to be true }
    it { expect(described_class.json_label?(jb, another_label)).to be false }
  end

  describe '.book' do
    let(:jb_additions) do
      {
        name: 'Such a Good Book',
        customFieldItems: [{
          idCustomField: author_field[:id],
          value: { text: 'A Most Excellent Storyteller' } }]
      }
    end
    subject { Extract.book(hash, jb, all_lists) }
    it { expect(subject).to be_a Book }
    it { expect(subject.series).to eq nil }
    it { expect(subject.series_number).to eq nil }
    it { expect(subject.list).to eq book.list }

    it_behaves_like "a book attribute" do
      let(:attribute) { :title }
      let(:result) { 'Such a Good Book' }
      let(:additions) {{ name: result }}
    end

    describe 'author' do
      it_behaves_like "a custom field attribute" do
        let(:field) { author_field }
        let(:attribute) { :author }
        let(:result) { 'A Most Excellent Storyteller' }
      end

      context 'the author is not in a custom field' do
        let(:jb_additions) { { desc: 'Ghost Writer', customFieldItems: [] } }
        it { expect(subject).to have_attributes(author: 'Ghost Writer') }
      end
    end

    it_behaves_like "a custom field attribute" do
      let(:field) { series_field }
      let(:attribute) { :series }
      let(:result) { 'The Adventures' }
    end

    it_behaves_like "a custom field attribute" do
      let(:field) { series_number_field }
      let(:attribute) { :series_number }
      let(:result) { 3 }
    end

    it_behaves_like "a boolean attribute" do let(:label) { audiobook_label } end
    it_behaves_like "a boolean attribute" do let(:label) { ebook_label } end
    it_behaves_like "a boolean attribute" do let(:label) { nat_label } end
    it_behaves_like "a boolean attribute" do let(:label) { sleep_label } end
    it_behaves_like "a boolean attribute" do let(:label) { dnf_label } end
    it_behaves_like "a boolean attribute" do let(:label) { fav_label } end
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
