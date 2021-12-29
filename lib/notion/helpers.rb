# frozen_string_literal: true

module Helpers
  module Convert
    ALT_STATUSES = { '📖 Reading 📖' => 'current', 'Read 2021' => 'done' }

    def csv_converters
      CSV::HeaderConverters[:title] = method(:title)
      CSV::HeaderConverters[:formats] = method(:formats)
      CSV::Converters[:status] = method(:alt_status)
      CSV::Converters[:blank_to_nil] = method(:blank_to_nil)

      CSV::HeaderConverters[:all] = [ :title, :formats, :symbol ]
      CSV::Converters[:mine] = [ :all, :blank_to_nil, :status ]
    end

    def title(header)
      header == 'Name' || header == "\u{feff}Name" ? 'Title' : header
    end

    def formats(header)
      header == 'Format' || header == "\u{feff}Format" ? 'Formats' : header
    end

    def alt_status(status)
      ALT_STATUSES.include?(status) ? ALT_STATUSES[status] : status
    end

    def blank_to_nil(value)
      value && value.empty? ? nil : value
    end
  end
end
