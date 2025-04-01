class CreateForemanX509Requests < ActiveRecord::Migration[6.0]
  def change
    create_table :foreman_x509_requests do |t|
      t.bigint :certificate_id, null: false
      t.bigint :generation_id, null: false
      t.text :request
    end

    add_foreign_key :foreman_x509_requests, :foreman_x509_certificates, column: :certificate_id, name: :foreman_x509_request_for_certificate, on_delete: :cascade
    add_foreign_key :foreman_x509_requests, :foreman_x509_generations, column: :generation_id, name: :foreman_x509_request_for_generation, on_delete: :cascade

    remove_column :foreman_x509_generations, :request, :text
  end
end