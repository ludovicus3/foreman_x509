module ForemanX509
  class Generation < ::ApplicationRecord
    belongs_to :owner, class_name: 'ForemanX509::Certificate', inverse_of: :generations
    has_one :issuer, through: :owner, class_name: 'ForemanX509::Issuer'
    
    serialize :certificate, ForemanX509::CertificateSerializer
    serialize :key, ForemanX509::KeySerializer

    validates :active, uniqueness: { scope: :owner_id }, if: :active?

    before_save :deactivate_previous_generation, if: :active?

    def activate!
      update!(active: true)
    end

    private

    def deactivate_previous_generation
      owner.generations.where(active: true).update_all(active: false) unless owner.nil?
    end
  end
end