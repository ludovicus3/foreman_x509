module ForemanX509
  module Serializer
    class Certificate
      def self.dump(object)
        object = OpenSSL::X509::Certificate.new(object) if object.is_a? String
        
        object.to_pem unless object.blank?
      end

      def self.load(data)
        OpenSSL::X509::Certificate.new(data) unless data.blank?
      end
    end
  end
end
