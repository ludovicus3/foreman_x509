module ForemanX509
  module Serializer
    class Configuration
      def self.dump(object)
        object.to_s unless object.blank?
      end

      def self.load(data)
        if data.blank?
          OpenSSL::Config.new
        else
          OpenSSL::Config.parse(data)
        end
      end
    end
  end
end