module ForemanX509
  class RequestsController < ::ApplicationController
    before_action :find_resource

    def show
      respond_to do |format|
        format.der { send_data @request.to_der, filename: "#{@request.name}_req.der" }
        format.pem { send_data @request.to_pem, filename: "#{@request.name}_req.pem" }
        format.html
      end
    end

    def resource_class
      ForemanX509::Request
    end
  end
end