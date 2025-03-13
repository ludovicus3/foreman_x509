class InitializeForemanX509Schema < ActiveRecord::Migration[6.0]
  def change
    create_table :foreman_x509_certificates do |t|
      t.string :name, null: false
      t.string :description
      t.bigint :issuer_id
      t.text   :configuration

      t.timestamps
    end

    create_table :foreman_x509_generations do |t|
      t.bigint  :owner_id, null: false
      t.boolean :active, null: false, default: false
      t.text    :certificate
      t.text    :key

      t.timestamps
    end

    create_table :foreman_x509_issuers do |t|
      t.bigint :certificate_id, null: false
      t.bigint :serial
      t.bigint :crl_number
      t.text   :certificate_revocation_list

      t.timestamps
    end

    add_foreign_key :foreman_x509_certificates, :foreman_x509_issuers, column: :issuer_id, name: :foreman_x509_issuer_for_certificate, on_delete: :nullify
    add_foreign_key :foreman_x509_generations, :foreman_x509_certificates, column: :owner_id, name: :foreman_x509_owner_for_generation, on_delete: :cascade
    add_foreign_key :foreman_x509_issuers, :foreman_x509_certificates, column: :certificate_id, name: :foreman_x509_certificate_for_issuer
  end
end