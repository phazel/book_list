# frozen_string_literal: true

module Helpers
  def csv_converters
    CSV::HeaderConverters[:title] = lambda do |header|
      header == 'Name' || header == "\u{feff}Name" ? 'Title' : header
    end
    CSV::Converters[:status] = lambda do |status|
      ALT_STATUSES.include?(status) ? ALT_STATUSES[status] : status
    end
    CSV::Converters[:blank_to_nil] = lambda do |value|
      value && value.empty? ? nil : value
    end

    CSV::HeaderConverters[:all] = [ :title, :symbol ]
    CSV::Converters[:mine] = [ :all, :blank_to_nil, :status ]
  end
end
