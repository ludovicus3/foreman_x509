module ForemanX509
  class Builder
    def self.build_generation(subject)
      builder = new(subject)
      subject.generations.build(certificate: builder.certificate, request: builder.request, key: builder.key)
    end

    def self.create_generation(subject)
      builder = new(subject)
      subject.generations.create(certificate: builder.certificate, request: builder.request, key: builder.key)
    end

    attr_reader :subject, :issuer, :certificate, :request, :key

    def initialize(subject)
      @subject = subject
      @issuer = subject.issuer
      @issuer ||= Issuer.new(certificate: subject) if subject.can_self_sign?
      @issuer ||= Issuer.new(certificate: Certificate.new)

      @key = (subject.key || OpenSSL::PKey::RSA.new(key_bits))
      
      @certificate = OpenSSL::X509::Certificate.new unless issuer.external?
      @request = OpenSSL::X509::Request.new if issuer.external?

      build_certificate
      build_request
    end

    private

    def self_signing?
      issuer.certificate == subject
    end

    def build_certificate
      return if issuer.external?

      certificate.subject = subject.subject
      certificate.public_key = key.public_key
      certificate.version = 2

      certificate.issuer = issuer.subject
      certificate.serial = issuer.serial!
      certificate.not_before = issuer.start_date
      certificate.not_after = issuer.end_date
      
      certificate_extensions do |extension|
        certificate.add_extension extension
      end
      
      certificate.sign(signing_key, issuer.digest)
    end

    def build_request
      return unless issuer.external?

      request.public_key = key.public_key
      request.version = 0
      request.subject = subject.subject

      request.add_attribute OpenSSL::X509::Attribute.new('extReq', OpenSSL::ASN1::Set([OpenSSL::ASN1::Sequence(request_extensions)]))

      request.sign(key, subject.digest)
    end

    def request_extensions
      subject.requested_extensions.map do |key, value|
        extension_factory.create_extension(key, value)
      end
    end

    def certificate_extensions
      issuer.certificate_extensions(subject.requested_extensions, subject.certificate_extensions_section).each do |key, value|
        extension = extension_factory.create_extension(key, value)
        yield extension if block_given?
      end
    end

    def key_bits
      return 4096 if subject.configuration.get_value('req', 'default_bits').nil?
      subject.configuration.get_value('req', 'default_bits').to_i
    end

    def extension_factory
      @extension_factory ||= OpenSSL::X509::ExtensionFactory.new(signing_certificate, certificate, request)
    end

    def signing_certificate
      return certificate if self_signing?
      issuer.certificate.certificate
    end

    def signing_key
      return key if self_signing?
      issuer.certificate.key
    end
  end
end