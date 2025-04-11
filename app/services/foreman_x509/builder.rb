module ForemanX509
  class Builder
    def self.create(subject)
      new(subject).create
    end

    attr_reader :subject, :issuer, :request, :generation
    attr_accessor :activate

    def initialize(subject, **options)
      @subject = subject
      @issuer = subject.issuer
      @issuer ||= Issuer.new(certificate: subject) if subject.can_self_sign?

      @activate = options.fetch(:activate, true)
    end

    def create
      @generation = subject.generations.create(key: key)

      if issuer
        build_certificate

        generation.update(certificate: certificate, active: activate)
      else
        @request = Request.create(certificate: @subject, generation: @generation)
      end

      generation
    end

    private

    def key
      @key ||= (subject.key || OpenSSL::PKey::RSA.new(subject.key_bits))
    end

    def certificate
      @certificate ||= OpenSSL::X509::Certificate.new
    end

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

    def certificate_extensions
      issuer.certificate_extensions(subject.requested_extensions, subject.certificate_extensions_section).each do |key, value|
        extension = extension_factory.create_extension(key, value)
        yield extension if block_given?
      end
    end

    def extension_factory
      @extension_factory ||= OpenSSL::X509::ExtensionFactory.new(signing_certificate, certificate, nil)
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