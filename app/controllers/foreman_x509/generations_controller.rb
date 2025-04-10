module ForemanX509
  class GenerationsController < ::ApplicationController

    before_action :find_owner
    before_action :find_generation, except: [:new, :create]
    before_action :upload_certificate_file, only: [:create, :update]

    def new
      @generation = ForemanX509::Generation.new(owner: @owner)
    end

    def create
      @generation = ForemanX509::Builder.create(@owner) if generation_params.empty?
      @generation = @owner.generations.create(generation_params) unless generation_params.empty?
      if @generation
        process_success object: @generation, success_redirect: certificate_path(@owner)
      else
        process_error object: @generation, redirect: certificate_path(@owner)
      end
    end

    def update
      if @generation.update(generation_params)
        process_success object: @generation, success_redirect: certificate_path(@owner)
      else
        process_error object: @generation, redirect: request_path(@generation.request)
      end
    end

    def activate
      @generation.activate!
      
      redirect_to certificate_path(@owner)
    end

    def certificate
      send_data @generation.certificate.to_pem, filename: "#{@generation.owner.name}-#{@generation.id}_cert.pem"
    end

    def key
      send_data @generation.key.to_pem, filename: "#{@generation.owner.name}-#{@generation.id}_key.pem"
    end

    def destroy
      if @generation.destroy
        process_success object: @generation, success_redirect: certificate_path(@owner)
      else
        process_error object: @generation, redirect: certificate_path(@owner)
      end
    end

    private

    def find_owner
      @owner ||= ForemanX509::Certificate.friendly.find(params[:owner_id])
    end

    def find_generation
      @generation ||= ForemanX509::Generation.find_by(owner: find_owner, id: params[:id])
    end

    def upload_certificate_file
      return if (certificate = params.dig(:generation, :certificate_file)).nil?
      params[:generation][:certificate] = certificate.read if certificate.respond_to?(:read)
    end

    def generation_params
      params.require(:generation).permit(:certificate)
    end
  end
end