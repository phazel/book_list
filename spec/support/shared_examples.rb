shared_examples "a custom field" do
  let(:field) { { id: 'f_id', name: 'Field Name', type: field_type } }
  let(:default) { 'something default' }

  subject { Extract.book_custom_field(jb, field) }
  it { expect(subject).to eq expected }

  context 'a default value is given' do
    subject { Extract.book_custom_field(jb, field, default: default) }
    it { expect(subject).to eq expected_with_default }
  end
end

shared_examples "a non-empty custom field" do
  let(:jb_additions) do
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

shared_examples "a book attribute" do
  let(:jb_additions) { {} }
  it { expect(subject).to have_attributes(attribute => nil) }

  context 'when the json is present' do
    let(:jb_additions) { additions }
    it { expect(subject).to have_attributes(attribute => result) }
  end
end

shared_examples "a custom field attribute" do
    let(:type) { { Integer => :number, String => :text }[result.class] }
    let(:item) { {idCustomField: field[:id], value: {type => result}} }

    it_behaves_like "a book attribute" do
      let(:additions) { { customFieldItems: [ item ] } }
    end
end

shared_examples "a boolean attribute" do
  let(:attribute) { label[:name].to_sym }
  it { expect(subject).to have_attributes(attribute => false) }

  context 'when the label is present' do
    let(:jb_additions) { { idLabels: [label[:id]] } }
    it { expect(subject).to have_attributes(attribute => true) }
  end
end
