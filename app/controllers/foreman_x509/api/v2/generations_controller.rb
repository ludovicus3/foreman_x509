module ForemanX509
  module Api
    module V2
      class GenerationsController < BaseController
        before_action :find_certificate
        before_action :find_generation, except: [:index, :create]

        api :GET, '/certificates/:certificate_id/generations', N_('List certificate generations')
        param :certificate_id, Integer, desc: N_('ID of the owning certificate')
        param_group :search_and_pagination, ::Api::V2::BaseController
        def index
          @generations = resource_scope_for_index
        end

        api :GET, '/certificates/:certificate_id/generations/:id', N_('Get generation details')
        param :certificate_id, Integer, desc: N_('ID of the owning certificate')
        param :id, Integer, desc: N_('ID of the generation')
        def show
        end

        api :GET, '/certificates/:certificate_id/generations/:id/certificate', N_('Download the generation certificate')
        param :certificate_id, Integer, desc: N_('ID of the owning certificate')
        param :id, Integer, desc: N_('ID of the generation')

        api :POST, '/certificates/:certificate_id/generations/:id/certificate', N_('Upload the generation certificate')
        param :certificate_id, Integer, desc: N_('ID of the owning certificate')
        param :id, Integer, desc: N_('ID of the generation')
        param :certificate, desc: N_('Certificate')
        def certificate
          if request.get?
            send_data @generation.certificate.to_pem, filename: "#{@generation.owner.name}-#{@generation.id}_cert.pem"
          else # post?
            certificate = params[:generation][:certificate]
            params[:generation][:certificate] = certificate.read if certificate.respond_to?(:read)

            render :show
          end
        end

        api :GET, '/certificates/:certificate_id/generations/:id/request', N_('Download the generation request')
        param :certificate_id, Integer, desc: N_('ID of the owning certificate')
        param :id, Integer, desc: N_('ID of the generation')
        def signing_request
          send_data @generation.request.to_pem, filename: "#{@generation.owner.name}-#{@generation.id}_req.pem"
        end

        api :GET, '/certificates/:certificate_id/generations/:id/key', N_('Download the generation key')
        param :certificate_id, Integer, desc: N_('ID of the owning certificate')
        param :id, Integer, desc: N_('ID of the generation')
        def key
          send_data @generation.key.to_pem, filename: "#{@generation.owner.name}-#{@generation.id}_key.pem"
        end

        api :POST, '/certificates/:certificate_id/generations/:id', N_('Activate certificate generation')
        param :certificate_id, Integer, desc: N_('ID of the owning certificate')
        param :id, Integer, desc: N_('ID of the generation')
        def activate
          @generation.activate!
        end

        api :DELETE, '/certificates/:certificate_id/generations/:id', N_('Delete certificate generation')
        def destroy
          @generation.destroy
        end

        private

        def find_certificate
          @certificate ||= ForemanX509::Certificate.find(params[:certificate_id])
        end

        def find_generation
          @generation ||= find_certificate.generations.find_by(id: params[:id])
        end
      end
    end
  end
end