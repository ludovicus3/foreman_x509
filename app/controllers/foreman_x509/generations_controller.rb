module ForemanX509
  class GenerationsController < ::ApplicationController

    before_action :find_certificate
    before_action :find_resource, except: [:new, :create]

    def new
      @generation = @certificate.generations.build
    end

    def create
      if @certificate.generations.create(generation_params)
        process_success object: @generation
      else
        process_error object: @generation
      end
    end

    def show
    end

    def activate
      @generation.activate!
    end

    def certificate
      send_data @generation.certificate.to_pem, filename: "#{@generation.owner.name}-#{@generation.id}_cert.pem"
    end

    def signing_request
      send_data @generation.request.to_pem, filename: "#{@generation.owner.name}-#{@generation.id}_req.pem"
    end

    def key
      send_data @generation.key.to_pem, filename: "#{@generation.owner.name}-#{@generation.id}_key.pem"
    end

    def destroy
      if @generation.destroy
        process_success object: @generation
      else
        process_error object: @generation
      end
    end

    def resource_class
      ForemanX509::Generation
    end

    private

    def find_certificate
      @certificate = Certificate.find(params[:certificate_id])
    end
  end
end