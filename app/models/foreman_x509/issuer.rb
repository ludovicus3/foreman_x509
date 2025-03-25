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

    delegate :name, :description, :description=, :configuration, :configuration=, to: :certificate

    validate :validate_authority_section, unless: -> { configuration.blank? }

    def external?
      certificate.key.nil?
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
      end_date = Time.parse(end_date) unless end_date.nil?
      if end_date.nil?
        days = configuration.get_value(authority_section, 'default_days').to_i.days
        end_date = start_date + days
      end
      end_date ||= start_date + 3650.days # TODO: make Setting[:default_certificate_days]
      end_date
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