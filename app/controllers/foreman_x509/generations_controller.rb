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

    def activate
      @generation.activate!
    end

    def certificate
    end

    def key
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