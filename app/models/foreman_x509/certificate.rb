module ForemanX509
  class Certificate < ::ApplicationRecord
    belongs_to :authority, class_name: 'ForemanX509::Certificate'
    
    serialize :certificate, coder: ForemanX509::CertificateSerializer, type: OpenSSL::X509::Certificate
    serialize :key, coder: ForemanX509::CertificateSerializer, type: OpenSSL::PKey::PKey

    delegate :extensions, :issuer, :not_after, :not_before, :public_key, :serial, :subject, :version, to: :certificate

    def authoritative?
      return false if certificate.nil?

      basic = certificate.extensions.find { |ext| ext.oid == 'basicConstraints' }

      basic.nil? ? false : basic.value == 'CA:TRUE'
    end

    def active?
      return false if certificate.nil?

      (certificate.not_before..certificate.not_after).include? Time.now
    end

    def can_sign?
      authoritative? and key?
    end

  end
end