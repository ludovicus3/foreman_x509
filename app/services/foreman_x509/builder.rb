module ForemanX509
  class Builder
    attr_reader :subject, :issuer, :certificate, :request

    def initialize(subject)
      @subject = subject
      @issuer = subject.issuer
      if @issuer.nil?
        section = subject.configuration.get_value('req', 'x509_extensions')
        unless subject.configuration[section].empty?
          @issuer = Issuer.new(certificate: subject)
        end
      end

      build_request
      build_certificate
    end

    def key
      @key ||= subject.key || OpenSSL::PKey::RSA.new(key_bits)
    end

    private

    def initialize_certificate
      @certificate = OpenSSL::X509::Certificate.new
    end

    def initialize_request
      @request = OpenSSL::X509::Request.new
    end

    def build_certificate
      return if issuer.external?
      
      initialize_certificate

      certificate.public_key = key.public_key
      certificate.version = 2
      certificate.serial = issuer.serial!
      certificate.not_before = issuer.start_date
      certificate.not_after = issuer.end_date

      certificate.subject = subject.subject
      certificate.issuer = issuer.subject

      certificate_extensions do |extension|
        certificate.add_extension extension
      end
      
      certifcate.sign(signing_key, issuer.digest)
    end

    def build_request
      return unless issuer.external?

      initialize_request

      request.public_key = key.public_key
      request.version = 0
      request.subject = subject.subject

      request.add_attribute OpenSSL::X509::Attribute.new('extReq', OpenSSL::ASN1::Set([OpenSSL::ASN1::Sequence(request_extensions)]))

      request.sign(key, subject.digest)
      request
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
      subject.configuration.get_value('req', 'default_bits') || 4096
    end

    def extension_factory
      @extension_factory ||= OpenSSL::X509::ExtensionFactory.new(signing_certificate, certificate, request)
    end

    def signing_certificate
      return nil if issuer.nil? # externally signed
      return certificate if issuer.certificate == subject
      issuer.certificate.certificate
    end

    def signing_key
      return key if issuer.certificate == subject
      issuer.certificate.key
    end
  end
end