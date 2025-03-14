module ForemanX509
  class BigNumberSerializer
    def self.dump(object)
      object.to_s(16) unless object.nil?
    end

    def self.load(data)
      OpenSSL::BN.new(data, 16) unless data.blank?
    end
  end
end