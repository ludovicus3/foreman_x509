module ForemanX509
  module Serializer
    class CertificateRevocationList

      def self.dump(object)
        object.to_s unless object.blank?
      end

      def self.load(data)
        OpenSSL::X509::CRL.new(data) unless data.blank?
      end
    end
  end
end