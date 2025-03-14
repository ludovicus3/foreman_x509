module ForemanX509
  class CertificateSerializer

    def self.dump(object)
      object.to_pem unless object.blank?
    end

    def self.load(data)
      OpenSSL::X509::Certificate.new(data) unless data.blank?
    end

  end
end
