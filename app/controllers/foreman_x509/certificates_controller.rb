module ForemanX509
  class CertificatesController < ::ApplicationController
    before_action :upload_certificate_file, only: [:create, :update]
    before_action :upload_key_file, only: [:create, :update]
    before_action :upload_configuration_file, only: [:create, :update]
    before_action :find_resource, except: :index

    def index
      @certificates = resource_base
    end

    def new
      @certificate = Certificate.new
    end
  
    def create
      @certificate = Certificate.new(certificate_params)
      if @certificate.save

        process_success object: @certificate
      else
        process_error object: @certificate
      end
    end
  
    def show
    end
  
    def update
      if @certificate.update(certificate_params)
        process_success object: @certificate
      else
        process_error object: @certificate
      end
    end
  
    def certificate
      send_data @certificate.certificate.to_pem, filename: "#{@certificate.name}_cert.pem"
    end
  
    def key
      send_data @certificate.key.to_pem, filename: "#{@certificate.name}_key.pem"
    end
  
    def destroy
      if @certificate.destroy
        process_success object: @certificate
      else
        process_error object: @certificate
      end
    end

    def resource_class
      ForemanX509::Certificate
    end
  
    private

    def upload_configuration_file
      return if (configuration = params.dig(:certificate, :configuration)).nil?
      params[:certificate][:configuration] = configuration.read if configuration.respond_to?(:read)
    end
  
    def upload_certificate_file
      return if (certificate = params.dig(:certificate, :generations_attributes, :certificate)).nil?
      params[:certificate][:generations_attributes][:certificate] = certificate.read if certificate.respond_to?(:read)
    end
  
    def upload_key_file
      return if (key = params.dig(:certificate, :generations_attributes, :key)).nil?
      params[:certificate][:generations_attributes][:key] = key.read if key.respond_to?(:read)
    end

    def certificate_params
      params.require(:certificate).permit(:name, :description, :issuer_id, :configuration, generations_attributes: [:certificate, :key])
    end

  end
end