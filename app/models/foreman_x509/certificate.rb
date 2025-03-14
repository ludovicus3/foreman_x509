module ForemanX509
  class Certificate < ::ApplicationRecord
    include ForemanX509::Subject
    extend FriendlyId
    friendly_id :name

    belongs_to :issuer, class_name: 'ForemanX509::Issuer', inverse_of: :certificates

    has_many :generations, class_name: 'ForemanX509::Generation', foreign_key: :owner_id, inverse_of: :owner
    has_one :generation, -> { where(foreman_x509_generations: { active: true }) }, class_name: 'ForemanX509::Generation', foreign_key: :owner_id
    accepts_nested_attributes_for :generation
    
    serialize :configuration, ForemanX509::ConfigurationSerializer

    delegate :certificate, :key, to: :generation, allow_nil: true

    validates :name, format: { with: /\A[a-z][a-z0-9.-]*(?<!-)\z/, message: _("Invalid name format!") }

    before_save :ensure_active_generation, if: -> { generations.empty? }

    def authoritative?
      return false if certificate.nil?

      basic = certificate.extensions.find { |ext| ext.oid == 'basicConstraints' }

      basic.nil? ? false : basic.value.upcase == 'CA:TRUE'
    end

    def active?
      return false if certificate.nil?

      (certificate.not_before..certificate.not_after).include? Time.now
    end

    def can_sign?
      authoritative? and active? and key.exists?
    end

    def externally_signed?
      certificate.exists? and issuer.nil?
    end

    private

    def ensure_active_generation
      return if configuration.nil?
    end

  end
end