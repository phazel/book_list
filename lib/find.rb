class Find
  FAVOURITE_LABEL = 'fav'
  DNF_LABEL = 'dnf'

  def self.list(hash, list_name)
    hash['lists'].find{ |list| list['name'] == list_name }
  end

  def self.label(hash, label_name)
    hash['labels'].find{ |label| label['name'] == label_name }
  end

  def self.labels(hash, label_names=[FAVOURITE_LABEL, DNF_LABEL])
    label_names.map{ |name| [ name, label(hash, name) ] }.to_h
  end

  def self.custom_field(hash, field_name)
    hash['customFields'].find{ |field| field['name'] == field_name }
  end
end
