module ForemanX509
  class Engine < ::Rails::Engine
    isolate_namespace ForemanX509
    engine_name 'foreman_x509'

    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]

    # Add any db migrations
    initializer 'foreman_x509.load_app_instance_data' do |app|
      ForemanX509::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_x509.register_plugin', :before => :finisher_hook do |app|
      require 'foreman_x509/plugin'
    end

    # Include concerns in this config.to_prepare block
    # config.to_prepare do
    #   Host::Managed.include ForemanX509::HostExtensions
    #   HostsHelper.include ForemanX509::HostsHelperExtensions
    # rescue StandardError => e
    #   Rails.logger.warn "ForemanX509: skipping engine hook (#{e})"
    # end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanX509::Engine.load_seed
      end
    end
  end

  def self.table_name_prefix
    'foreman_x509_'
  end


  def self.use_relative_model_naming
    true
  end
end
