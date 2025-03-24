module ForemanX509
  module Digest
    extend ActiveSupport::Concern

    def digest
      algorithm = configuration.get_value(authority_section, 'default_md') if respond_to?(:authority_section)
      algorithm ||= configuration.get_value('req', 'default_md')
      OpenSSL::Digest.new(algorithm || 'sha256') # TODO: make Setting[:default_digest_algorithm]
    end
  end
end