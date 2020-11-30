require 'find'

list = { "id"=>"l_id", "name"=>"some_list" }
some_other_list = { "id"=>"al_id", "name"=>"some_other_list" }
another_list = { "id"=>"al_id", "name"=>"another_list" }
yet_another_list = { "id"=>"al_id", "name"=>"yet_another_list" }

label = { "id"=>"l_id", "name"=>"some_label" }
some_other_label = { "id"=>"sol_id", "name"=>"some_other_label" }
another_label = { "id"=>"al_id", "name"=>"another_label" }
yet_another_label = { "id"=>"yal_id", "name"=>"yet_another_label" }

field = { "id"=>"f_id", "name"=>"some_field" }
another_field = { "id"=>"af_id", "name"=>"some_other_field" }

hash = {
  "lists" => [ list, some_other_list, another_list, yet_another_list ],
  "labels" => [ label, some_other_label, another_label, yet_another_label ],
  "customFields" => [ field, another_field ]
}

describe Find do
  describe '.list' do
    it { expect(described_class.list(hash, list['name'])).to eq list }
    it { expect(described_class.list(hash, another_list['name'])).to eq another_list }
    it { expect(described_class.list(hash, 'does_not_exist')).to eq nil }
  end

  describe '.lists' do
    lists = ['some_list', 'another_list']
    expected = {
      "some_list"=> { "id"=>"l_id", "name"=>"some_list" },
      "another_list"=> { "id"=>"al_id", "name"=>"another_list" }
    }
    it { expect(described_class.lists(hash, 3040, lists)).to eq expected }
    it { expect(described_class.lists(hash, 250, [])).to be_empty }
  end

  describe '.label' do
    it { expect(described_class.label(hash, label['name'])).to eq label }
    it { expect(described_class.label(hash, another_label['name'])).to eq another_label }
    it { expect(described_class.label(hash, 'does_not_exist')).to eq nil }
  end

  describe '.labels' do
    labels = ['some_label', 'another_label']
    expected = {
      "some_label"=> { "id"=>"l_id", "name"=>"some_label" },
      "another_label"=> { "id"=>"al_id", "name"=>"another_label" }
    }
    it { expect(described_class.labels(hash, labels)).to eq expected }
    it { expect(described_class.labels(hash, [])).to be_empty }
  end

  describe '.custom_field' do
    it { expect(described_class.custom_field(hash, field['name'])).to eq field }
    it { expect(described_class.custom_field(hash, another_field['name'])).to eq another_field }
    it { expect(described_class.custom_field(hash, 'does_not_exist')).to eq nil }
  end
end
