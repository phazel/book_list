# frozen_string_literal: true

module Helpers
  module Convert
    ALT_STATUSES = { '📖 Reading 📖' => 'current', 'Read 2021' => 'done' }

    def csv_converters
      CSV::HeaderConverters[:title] = method(:title_converter)
      CSV::HeaderConverters[:formats] = method(:formats)
      CSV::HeaderConverters[:fav] = method(:fav)
      CSV::HeaderConverters[:tags] = method(:tags)
      CSV::Converters[:status] = method(:alt_status)
      CSV::Converters[:blank_to_nil] = method(:blank_to_nil)

      CSV::HeaderConverters[:all] = [ :title, :formats, :fav, :tags, :symbol ]
      CSV::Converters[:mine] = [ :all, :blank_to_nil, :status ]
    end

    def title_converter(header)
      header == 'Name' || header == "\u{feff}Name" ? 'Title' : header
    end

    def formats(header)
      header == 'Format' || header == "\u{feff}Format" ? 'Formats' : header
    end

    def fav(header)
      header == '⭐️' || header == "\u{feff}⭐️" ? 'Fav' : header
    end

    def tags(header)
      header == 'Labels' || header == "\u{feff}Labels" ? 'Tags' : header
    end

    def alt_status(status)
      ALT_STATUSES.include?(status) ? ALT_STATUSES[status] : status
    end

    def blank_to_nil(value)
      value && value.empty? ? nil : value
    end
  end
end
