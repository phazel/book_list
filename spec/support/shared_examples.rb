require "set"

RSpec.shared_examples "a custom field" do
  let(:field) { { id: 'f_id', name: 'Field Name', type: field_type } }
  let(:default) { 'something default' }

  subject { Extract.book_custom_field(json_book, field) }
  it { expect(subject).to eq expected }

  context 'a default value is given' do
    subject { Extract.book_custom_field(json_book, field, default: default) }
    it { expect(subject).to eq expected_with_default }
  end
end

RSpec.shared_examples "a non-empty custom field" do
  let(:json_book) do
    { customFieldItems: [{ idCustomField: field[:id], value: { field_type => field_value }}] }
  end
  let(:expected) { field_value }
  let(:expected_with_default) { field_value }

  it_behaves_like "a custom field"
end

RSpec.shared_examples "an empty custom field" do
  let(:field_type) { :text }
  let(:expected) { nil }
  let(:expected_with_default) { default }

  it_behaves_like "a custom field"
end
