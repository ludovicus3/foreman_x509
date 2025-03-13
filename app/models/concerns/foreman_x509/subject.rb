module ForemanX509
  module Subject
    extend ActiveSupport::Concern

    def subject
      @subject ||= subject_from_certificate
      @subject ||= subject_from_configuration
    end

    def subject_from_certificate
      certificate.subject unless certificate.nil?
    end

    def subject_from_configuration
      return if configuration.blank?

      section = configuration.get_value('req', 'distinguished_name')

      OpenSSL::X509::Name.new(configuration[section].to_a) unless section.nil?
    end

  end
end
