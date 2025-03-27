module ForemanX509
  module Api
    module V2
      class CertificatesController < BaseController
        resource_description do
          resource_id 'certificates'
          api_version 'v2'
          api_base_url '/foreman_x509/api'
        end

        before_action :find_resource, only: [:show, :destroy]

        api :GET, '/cycles', N_('List cycles')
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(Certificate)
        def index
          @certificates = resource_scope_for_index
        end

        def create
        end

        def show
        end

        def update
        end

        api :DELETE, '/certificates/:id', N_('Destroy a certificate')
        param :id, Integer, desc: N_('Id of the certificate')
        def destroy
          process_response @certificate.destroy
        end

        def resource_class
          ForemanX509::Certificate
        end
      end
    end
  end
end