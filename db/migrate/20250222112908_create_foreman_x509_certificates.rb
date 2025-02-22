class CreateForemanX509Certificates < ActiveRecord::Migration[6.0]
  def change
    create_table :foreman_x509_certificates do |t|
      t.string :common_name, null: false
      t.string :purpose, null: false
      t.bigint :authority_id
      t.text :certificate
      t.text :key

      t.timestamps

      t.index [:common_name, :purpose], unique: true, :certificate_by_common_name_and_purpose
    end

    add_foreign_key :foreman_x509_certificates, :foreman_x509_certificates, column: :authority_id, name: :authority_for_certificate
  end
end