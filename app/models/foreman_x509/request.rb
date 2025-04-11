module ForemanX509
  class Request < ::ApplicationRecord
    belongs_to :certificate, class_name: 'ForemanX509::Certificate'
    belongs_to :generation, class_name: 'ForemanX509::Generation'

    serialize :request, ForemanX509::Serializer::Request

    validates :certificate, presence: true
    validates :generation, presence: true

    delegate :name, to: :certificate
    delegate :to_pem, :to_der, to: :request

    before_save :create_request, unless: :request?

    private

    def create_request
      request = OpenSSL::X509::Request.new

      request.public_key = generation.key.public_key
      request.version = 0
      request.subject = certificate.subject

      request.add_attribute OpenSSL::X509::Attribute.new('extReq', OpenSSL::ASN1::Set([OpenSSL::ASN1::Sequence(request_extensions)]))

      self.request = request.sign(generation.key, certificate.digest)
    end

    def request_extensions
      certificate.requested_extensions.map do |key, value|
        extension_factory.create_extension(key, value)
      end
    end

    def extension_factory
      @extension_factory ||= OpenSSL::X509::ExtensionFactory.new(nil, nil, request)
    end
  end
end