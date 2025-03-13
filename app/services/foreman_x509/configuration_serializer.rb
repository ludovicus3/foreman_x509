module ForemanX509
  class ConfigurationSerializer
    def initialize(options = {})
    end

    def dump(object)
      object.to_s unless object.blank?
    end

    def load(data)
      OpenSSL::Config.parse(data) unless data.blank?
    end
  end
end