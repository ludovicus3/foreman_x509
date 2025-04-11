module ForemanX509
  class Generation < ::ApplicationRecord
    belongs_to :owner, class_name: 'ForemanX509::Certificate', inverse_of: :generations
    has_one :issuer, through: :owner, class_name: 'ForemanX509::Issuer'

    has_one :request, class_name: 'ForemanX509::Request', inverse_of: :generation
    
    serialize :certificate, ForemanX509::Serializer::Certificate
    serialize :key, ForemanX509::Serializer::Key

    delegate :not_before, :not_after, to: :certificate, allow_nil: true

    before_save :deactivate_previous_generation, if: :active?
    after_save :delete_associated_request, if: :certificate?

    scoped_search relation: :owner, on: :name, complete_value: true, rename: :owner

    validates :active, presence: true, if: :active?
    validates :active, uniqueness: { scope: :owner_id }, if: :active?
    validate :validate_certificate_key_pairing, unless: -> { certificate.blank? or key.blank? }

    def status
      return 'pending' if certificate.nil?

      return 'expired' if expired?

      return 'active' if active?

      'inactive'
    end

    def activate!
      update!(active: true)
    end

    def expired?
      return false unless certificate?
      
      not (certificate.not_before..certificate.not_after).include? Time.now
    end

    private

    def validate_certificate_key_pairing
      certificate.check_private_key(key)
    end

    def deactivate_previous_generation
      owner.generations.where(active: true).update_all(active: false) unless owner.nil?
    end

    def delete_associated_request
      unless request.nil?
        request.destroy
        
        activate!
      end
    end
  end
end