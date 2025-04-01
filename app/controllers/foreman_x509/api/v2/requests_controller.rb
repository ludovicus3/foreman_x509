module ForemanX509
  module Api
    module V2
      class RequestsController < BaseController
        resource_description do
          resource_id 'certificates'
          api_version 'v2'
          api_base_url '/foreman_x509/api'
        end

        before_action :find_resource, only: [:show, :download]

        def index
          @requests = resource_scope_for_index
        end

        def show
        end

        def download
          send_data @request.to_pem, filename: "#{@request.name}_req.pem"
        end
      end
    end
  end
end