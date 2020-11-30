require 'find'

list = { "id"=>"l_id", "name"=>"some_list" }
another_list = { "id"=>"al_id", "name"=>"some_other_list" }

label = { "id"=>"l_id", "name"=>"some_label" }
another_label = { "id"=>"al_id", "name"=>"some_other_label" }

field = { "id"=>"f_id", "name"=>"some_field" }
another_field = { "id"=>"af_id", "name"=>"some_other_field" }

hash = {
  "lists" => [ list, another_list ],
  "labels" => [ label, another_label ],
  "customFields" => [ field, another_field ]
}

describe Find do
  describe '.list' do
    it { expect(described_class.list(hash, list['name'])).to eq list }
    it { expect(described_class.list(hash, another_list['name'])).to eq another_list }
    it { expect(described_class.list(hash, 'does_not_exist')).to eq nil }
  end

  describe '.label' do
    it { expect(described_class.label(hash, label['name'])).to eq label }
    it { expect(described_class.label(hash, another_label['name'])).to eq another_label }
    it { expect(described_class.label(hash, 'does_not_exist')).to eq nil }
  end

  describe '.custom_field' do
    it { expect(described_class.custom_field(hash, field['name'])).to eq field }
    it { expect(described_class.custom_field(hash, another_field['name'])).to eq another_field }
    it { expect(described_class.custom_field(hash, 'does_not_exist')).to eq nil }
  end
end
