module ForemanX509
  module Serializer
    class BigNumber
      def self.dump(object)
        object.to_s(16) unless object.nil?
      end

      def self.load(data)
        OpenSSL::BN.new(data, 16) unless data.blank?
      end
    end
  end
end