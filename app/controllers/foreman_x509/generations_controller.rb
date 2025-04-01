module ForemanX509
  class GenerationsController < ::ApplicationController

    before_action :find_certificate
    before_action :find_generation, except: [:new, :create]
    before_action :upload_certificate_file, only: [:create, :update]

    def new
      @generation = ForemanX509::Generation.new(owner: @certificate)
    end

    def create
      @generation = ForemanX509::Builder.create(@certificate) if generation_params.empty?
      @generation = @certificate.generations.create(generation_params) unless generation_params.empty?
      if @generation
        process_success object: @generation, redirect: certificate_path(@certificate)
      else
        process_error object: @generation, redirect: certificate_path(@certificate)
      end
    end

    def edit
    end

    def update
      if @generation.update(generation_params)
        process_success object: @generation, redirect: certificate_path(@certificate)
      else
        process_error object: @generation, redirect: edit_certificate_generation_path(certificate_id: @certificate, id: @generation)
      end
    end

    def activate
      @generation.activate!
    end

    def certificate
      send_data @generation.certificate.to_pem, filename: "#{@generation.owner.name}-#{@generation.id}_cert.pem"
    end

    def key
      send_data @generation.key.to_pem, filename: "#{@generation.owner.name}-#{@generation.id}_key.pem"
    end

    def destroy
      if @generation.destroy
        process_success object: @generation, redirect: certificate_path(@certificate)
      else
        process_error object: @generation, redirect: certificate_path(@certificate)
      end
    end

    private

    def find_certificate
      @certificate ||= ForemanX509::Certificate.friendly.find(params[:certificate_id])
    end

    def find_generation
      @generation ||= find_certificate.generations.find_by(id: params[:id])
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