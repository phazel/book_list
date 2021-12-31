# frozen_string_literal: true

module Helpers
  module Convert
    def csv_converters
      CSV::HeaderConverters[:title] = method(:title_converter)
      CSV::HeaderConverters[:formats] = method(:formats)
      CSV::HeaderConverters[:fav] = method(:fav)
      CSV::Converters[:blank_to_nil] = method(:blank_to_nil)

      CSV::HeaderConverters[:all] = [ :title, :formats, :fav, :symbol ]
      CSV::Converters[:mine] = [ :all, :blank_to_nil ]
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

    def blank_to_nil(value)
      value && value.empty? ? nil : value
    end
  end
end
