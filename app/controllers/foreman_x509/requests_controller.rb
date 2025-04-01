module ForemanX509
  class RequestsController < ::ApplicationController
    before_action :find_resource

    def show
      send_data @request.to_pem, filename: "#{@request.name}_req.pem"
    end

    def resource_class
      ForemanX509::Request
    end
  end
end