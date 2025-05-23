module ForemanX509
  module Api
    module V2
      class RequestsController < BaseController
        resource_description do
          resource_id 'requests'
          api_version 'v2'
          api_base_url '/foreman_x509/api'
        end

        before_action :find_resource, only: [:show, :download]

        def index
          @requests = resource_scope_for_index
        end

        def show
          respond_to do |format|
            format.der { send_data @request.to_der, filename: "#{@request.name}_req.der" }
            format.pem { send_data @request.to_pem, filename: "#{@request.name}_req.pem" }
            format.json
          end
        end

        def resource_class
          ForemanX509::Request
        end
        
      end
    end
  end
end