module ForemanX509
  class IssuersController < ::ApplicationController

    before_action :find_resource, only: [:show, :destroy]

    def index
      @issuers = resource_base_search_and_page
    end

    def new
      @issuer = Issuer.new
    end

    def create
      if @issuer.create(issuer_params)
        process_success object: @issuer
      else
        process_error object: @issuer
      end
    end

    def show
    end

    def bundle
      send_data @issuer.bundle.map(&:to_pem).join('\n'), filename: "#{@issuer.name}_bundle.pem"
    end

    def destroy
      if @issuer.destroy
        process_success object: @issuer
      else
        process_error object: @issuer
      end
    end

    private

    def issuer_params_for_create
      params.require(:issuer).permit(:certificate_id, :serial, :crl_number, :certificate_revocation_list,
                                     certificate_attributes: [:name, :issuer_id, :description, :configuration, generation_attributes: [:certificate, :key]])
    end

  end
end