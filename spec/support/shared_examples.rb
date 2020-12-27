shared_examples "a custom field" do
  let(:field) { { id: 'f_id', name: 'Field Name', type: field_type } }
  let(:default) { 'something default' }

  subject { Extract.book_custom_field(json_book, field) }
  it { expect(subject).to eq expected }

  context 'a default value is given' do
    subject { Extract.book_custom_field(json_book, field, default: default) }
    it { expect(subject).to eq expected_with_default }
  end
end

shared_examples "a non-empty custom field" do
  let(:json_book) do
    { customFieldItems: [{ idCustomField: field[:id], value: { field_type => field_value }}] }
  end
  let(:expected) { field_value }
  let(:expected_with_default) { field_value }

  it_behaves_like "a custom field"
end

shared_examples "an empty custom field" do
  let(:field_type) { :text }
  let(:expected) { nil }
  let(:expected_with_default) { default }

  it_behaves_like "a custom field"
end

shared_examples "a boolean attribute" do
  let(:json_book_with_label) { json_book.merge({ idLabels: [label[:id]] }) }
  let(:attribute) { label[:name].to_sym }

  subject { Extract.book(hash, json_book_with_label, all_lists) }
  it { expect(subject).to have_attributes(attribute => true) }
end
