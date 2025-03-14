module ForemanX509
  class KeySerializer

    def self.dump(object)
      object.to_s unless object.blank?
    end

    def self.load(data)
      OpenSSL::PKey.read(data) unless data.blank?
    end

  end
end
