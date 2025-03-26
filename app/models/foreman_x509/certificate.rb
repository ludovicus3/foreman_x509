module ForemanX509
  class Certificate < ::ApplicationRecord
    include ForemanX509::Subject
    include ForemanX509::Extensions
    include ForemanX509::Digest
    extend FriendlyId
    friendly_id :name

    belongs_to :issuer, class_name: 'ForemanX509::Issuer', inverse_of: :certificates

    has_many :generations, class_name: 'ForemanX509::Generation', foreign_key: :owner_id, inverse_of: :owner
    has_one :generation, -> { where(foreman_x509_generations: { active: true }) }, class_name: 'ForemanX509::Generation', foreign_key: :owner_id
    accepts_nested_attributes_for :generation
    
    serialize :configuration, ForemanX509::Serializer::Configuration

    delegate :certificate, :request, :key, to: :generation, allow_nil: true

    validates :name, format: { with: /\A[a-z][a-z0-9.-]*(?<!-)\z/, message: _("Invalid name format!") }
    validates :certificate, presence: true, if: -> { configuration.nil? }
    validate :configuration_has_required_fields, unless: -> { configuration.nil? }

    before_save :ensure_active_generation, if: -> { generations.empty? }

    scoped_search on: :name, complete_value: true

    def can_self_sign?
      return false if configuration.nil?

      section = configuration.get_value('req', 'x509_extensions')
      configuration[section].present?
    end

    def active?
      return false if certificate.nil?

      (not_before..not_after).include? Time.now
    end

    def not_before
      certificate.not_before unless certificate.nil?
    end

    def not_after
      certificate.not_after unless certificate.nil?
    end

    def requested_extensions
      extensions_from_section(configuration.get_value('req', 'req_extensions'))
    end

    def certificate_extensions_section
      configuration.get_value('req', 'x509_extensions')
    end

    private

    def configuration_has_required_fields
      errors.add("Configuration missing distinguished name definition") if subject_from_configuration.nil?
    end

    def ensure_active_generation
      return if configuration.nil?
    end
  end
end