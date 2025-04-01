module ForemanX509
  class RequestsController < ::ApplicationController
    before_action :find_resource

    def show
    end

    def resource_class
      ForemanX509::Request
    end
  end
end