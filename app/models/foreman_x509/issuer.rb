module ForemanX509
  class Issuer < ::ApplicationRecord
    include ForemanX509::Subject
    include ForemanX509::Extensions
    include ForemanX509::Digest
    
    belongs_to :certificate, class_name: 'ForemanX509::Certificate'
    accepts_nested_attributes_for :certificate

    has_many :certificates, class_name: 'ForemanX509::Certificate', inverse_of: :issuer

    serialize :serial, ForemanX509::Serializer::BigNumber
    serialize :certificate_revocation_list, ForemanX509::Serializer::CertificateRevocationList

    delegate :name, :description, :configuration, to: :certificate

    validate :validate_authority_section, unless: -> { configuration.blank? }

    scoped_search relation: :certificate, on: :name, complete_value: true

    def external?
      configuration.nil?
    end

    def self_signing?
      certificate.issuer == self
    end

    def serial!
      next_serial = serial || SecureRandom.hex(16)
      update_attribute(:serial, next_serial + 1) unless new_record?
      next_serial
    end

    def start_date
      start_date = configuration.get_value(authority_section, 'default_startdate')
      start_date = Time.parse(start_date) unless start_date.nil?
      start_date || Time.now
    end

    def end_date
      end_date = configuration.get_value(authority_section, 'default_enddate')
      if end_date.nil?
        duration = configuration.get_value(authority_section, 'default_days')
        start_date + (duration.nil? ? 3650.days : duration.to_i.days) # TODO: make Setting[:default_certificate_days]
      else
        Time.parse(end_date)
      end
    end

    def certificate_extensions(requested_extensions, section = nil)
      section ||= default_certificate_extensions_section
      case copy_extensions
      when 'copy'
        requested_extensions.merge(extensions_from_section(section))
      when 'copyall'
        extensions_from_section(section).merge(requested_extensions)
      else # 'none'
        extensions_from_section(section)
      end
    end

    def bundle
      return [ certificate.certificate ] if certificate.issuer.nil? or certificate.issuer == self

      [ certificate.certificate ] + certificate.issuer.bundle
    end

    private

    def default_certificate_extensions_section
      configuration.get_value(authority_section, 'x509_extensions')
    end

    def copy_extensions
      configuration.get_value(authority_section, 'copy_extensions') || 'none'
    end

    def authority_section
      configuration.get_value('ca', 'default_ca')
    end

    def validate_authority_section
      errors.add(:configuration, "missing 'default_ca' from 'ca' section") if authority_section.nil?
    end
  end
end