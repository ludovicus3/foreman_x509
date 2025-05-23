module ForemanX509
  module Serializer
    class Configuration
      def self.dump(object)
        object.to_s unless object.blank?
      end

      def self.load(data)
        OpenSSL::Config.parse(data) unless data.blank?
      end
    end
  end
end