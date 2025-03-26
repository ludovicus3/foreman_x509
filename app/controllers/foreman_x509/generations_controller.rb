module ForemanX509
  class GenerationsController < ::ApplicationController

    before_action :find_resource, except: :index

    def index
      @generations = resource_scope(owner_id: params[:certificate_id])
    end

    def create
      if @generation.create(generation_params)
        process_success object: @generation
      else
        process_error object: @generation
      end
    end

    def show
    end

    def update
      if @generation.update(generation_params)
        process_success object: @generation
      else
        process_error object: @generation
      end
    end

    def activate
      @generation.activate!
    end

    def certificate
      send_data @generation.certificate.to_pem, filename: "#{@generation.owner.name}-#{@generation.id}_cert.pem"
    end

    def request
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
  end
end