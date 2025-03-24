module ForemanX509
  class Generation < ::ApplicationRecord
    belongs_to :owner, class_name: 'ForemanX509::Certificate', inverse_of: :generations
    has_one :issuer, through: :owner, class_name: 'ForemanX509::Issuer'
    
    serialize :certificate, ForemanX509::Serializer::Certificate
    serialize :key, ForemanX509::Serializer::Key

    before_save :deactivate_previous_generation, if: :active?

    validates :active, uniqueness: { scope: :owner_id }, if: :active?
    validate :validate_certificate_key_pairing, unless: -> { certificate.blank? or key.blank? }

    def activate!
      update!(active: true)
    end

    private

    def validate_certificate_key_pairing
      certificate.check_private_key(key)
    end

    def deactivate_previous_generation
      owner.generations.where(active: true).update_all(active: false) unless owner.nil?
    end
  end
end