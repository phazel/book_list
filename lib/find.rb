class Find
  FAVOURITE_LABEL = 'fav'
  DNF_LABEL = 'dnf'
  CURRENTLY_READING_LIST = "📖 Reading 📖"
  def self.READ(year) "Read #{year}" end

  def self.list(hash, list_name)
    hash['lists'].find{ |list| list['name'] == list_name }
  end

  def self.lists(hash, year, list_names=nil)
    if list_names.nil?
      {
        "read"=> list(hash, READ(year)),
        "current"=> list(hash, CURRENTLY_READING_LIST)
      }
    else
      list_names.map{ |name| [ name, list(hash, name) ] }.to_h
    end
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
