module ForemanX509
  module Api
    module V2
      class IssuersController < BaseController
        resource_description do
          resource_id 'issuer'
          api_version 'v2'
          api_base_url '/foreman_x509/api'
        end

        before_action :find_resource, only: [:show, :destroy]

        api :GET, '/issuers', N_('List issuers')
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(ForemanX509::Issuer)
        def index
          @certificates = resource_scope_for_index
        end

        def create
        end

        def show
        end

        def update
        end

        api :DELETE, '/issuer/:id', N_('Destroy an issuer')
        param :id, Integer, desc: N_('Id of the issuer')
        def destroy
          process_response @issuer.destroy
        end

        def resource_class
          ForemanX509::Issuer
        end
      end
    end
  end
end