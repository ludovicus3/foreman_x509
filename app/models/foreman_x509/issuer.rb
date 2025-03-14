module ForemanX509
  class Issuer < ::ApplicationRecord
    include ForemanX509::Subject
    
    belongs_to :certificate, class_name: 'ForemanX509::Certificate'
    accepts_nested_attributes_for :certificate

    has_many :certificates, class_name: 'ForemanX509::Certificate', inverse_of: :issuer

    attribute :serial, default: -> { SecureRandom.hex(8).to_i(16) }
    serialize :certificate_revocation_list, ForemanX509::CertificateRevocationListSerializer

    delegate :name, :description, :configuration, to: :certificate
  end
end