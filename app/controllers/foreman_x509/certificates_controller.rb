module ForemanX509
  class CertificatesController < ::ApplicationController
    before_action :upload_certificate_file, only: [:create, :update]
    before_action :upload_key_file, only: [:create, :update]
    before_action :upload_configuration_file, only: [:create, :update]
    before_action :find_resource, except: [:index, :new, :create]

    helper ForemanX509::GenerationsHelper

    def index
      @certificates = resource_base_search_and_page
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

    def signing_request
      send_data @certificate.request.to_pem, filename: "#{@certificate.name}_req.pem"
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
      return if (configuration = params.dig(:certificate, :configuration_file)).nil?
      params[:certificate][:configuration] = configuration.read if configuration.respond_to?(:read)
    end
  
    def upload_certificate_file
      return if (certificate = params.dig(:certificate, :generation_attributes, :certificate_file)).nil?
      params[:certificate][:generation_attributes][:certificate] = certificate.read if certificate.respond_to?(:read)
    end
  
    def upload_key_file
      return if (key = params.dig(:certificate, :generation_attributes, :key_file)).nil?
      params[:certificate][:generation_attributes][:key] = key.read if key.respond_to?(:read)
    end

    def certificate_params
      params.require(:certificate).permit(:name, :description, :issuer_id, :configuration, generation_attributes: [:certificate, :key])
    end

  end
end