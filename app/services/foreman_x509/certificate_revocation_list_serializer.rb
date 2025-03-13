module ForemanX509
  class CertificateRevocationListSerializer
    def initialize(options = {})
    end

    def dump(object)
      object.to_pem unless object.blank?
    end

    def load(data)
      OpenSSL::X509::CRL.new(data) unless data.blank?
    end
  end
end