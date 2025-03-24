module ForemanX509
  class Issuer < ::ApplicationRecord
    include ForemanX509::Subject
    
    belongs_to :certificate, class_name: 'ForemanX509::Certificate'
    accepts_nested_attributes_for :certificate

    has_many :certificates, class_name: 'ForemanX509::Certificate', inverse_of: :issuer

    serialize :serial, ForemanX509::Serializer::BigNumber
    serialize :certificate_revocation_list, ForemanX509::Serializer::CertificateRevocationList

    delegate :name, :description, :description=, :configuration, :configuration=, to: :certificate
  end
end