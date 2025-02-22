module ForemanX509
  class CertificateSerializer
    def initialize(options = {})
    end

    def dump(object)
      object.to_pem unless object.blank?
    end

    def load(data)
      OpenSSL::X509::Certificate.new(data) unless data.blank?
    end
  end
end
