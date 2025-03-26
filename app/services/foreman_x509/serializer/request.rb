module ForemanX509
  module Serializer
    class Request
      def self.dump(object)        
        object.to_pem unless object.blank?
      end

      def self.load(data)
        OpenSSL::X509::Request.new(data) unless data.blank?
      end
    end
  end
end