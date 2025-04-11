module ForemanX509
  module Api
    module V2
      class GenerationsController < BaseController
        before_action :find_owner
        before_action :find_generation, except: [:index, :create]

        api :GET, '/certificates/:owner_id/generations', N_('List certificate generations')
        param :certificate_id, Integer, desc: N_('ID of the owning certificate')
        param_group :search_and_pagination, ::Api::V2::BaseController
        def index
          @generations = resource_scope_for_index
        end

        api :GET, '/certificates/:owner_id/generations/:id', N_('Get generation details')
        param :certificate_id, Integer, desc: N_('ID of the owning certificate')
        param :id, Integer, desc: N_('ID of the generation')
        def show
        end

        api :GET, '/certificates/:owner_id/generations/:id/certificate', N_('Download the generation certificate')
        param :certificate_id, Integer, desc: N_('ID of the owning certificate')
        param :id, Integer, desc: N_('ID of the generation')
        def certificate
        end

        api :GET, '/certificates/:owner_id/generations/:id/key', N_('Download the generation key')
        param :certificate_id, Integer, desc: N_('ID of the owning certificate')
        param :id, Integer, desc: N_('ID of the generation')
        def key
          send_data @generation.key.to_pem, filename: "#{@generation.owner.name}-#{@generation.id}_key.pem"
        end

        api :POST, '/certificates/:owner_id/generations/:id', N_('Activate certificate generation')
        param :certificate_id, Integer, desc: N_('ID of the owning certificate')
        param :id, Integer, desc: N_('ID of the generation')
        def activate
          @generation.activate!
        end

        api :DELETE, '/certificates/:owner_id/generations/:id', N_('Delete certificate generation')
        def destroy
          @generation.destroy
        end

        private

        def find_owner
          @owner ||= ForemanX509::Certificate.find(params[:owner_id])
        end

        def find_generation
          @generation ||= find_certificate.generations.find_by(id: params[:id])
        end
      end
    end
  end
end