module ForemanX509
  class KeySerializer
    def initialize(options = {})
    end

    def dump(object)
      object.to_pem unless object.blank?
    end

    def load(data)
      OpenSSL::PKey.load(data) unless data.blank?
    end
  end
end
