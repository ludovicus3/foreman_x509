module ForemanX509
  module Extensions
    extend ActiveSupport::Concern

    EXTENSION_ENTRY_FORMAT = /\A(?<critical>critical,)?\s*(?:@(?<section>[a-zA-Z_]+)|(?<value>[^@].*))\Z/.freeze

    def extensions_from_section(section)
      return {} if section.nil?

      configuration[section].transform_values do |value|
        data = EXTENSION_ENTRY_FORMAT.match(value)
        data[:critical].to_s + (data[:value] || extension_value_from_section(data[:section])).to_s
      end
    end

    def extension_value_from_section(section)
      configuration[section].entries.map { |entry| entry.join(':') }.join(',')
    end
  end
end