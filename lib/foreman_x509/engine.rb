module ForemanX509
  class Engine < ::Rails::Engine
    isolate_namespace ForemanX509
    engine_name 'foreman_x509'

    # Add any db migrations
    initializer 'foreman_x509.load_app_instance_data' do |app|
      ForemanX509::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_x509.register_plugin', :before => :finisher_hook do |app|
      app.reloader.to_prepare do
        Foreman::Plugin.register :foreman_x509 do
          requires_foreman '>= 3.11.0'
          register_gettext

          # Add Global files for extending foreman-core components and routes
          # register_global_js_file 'global'

          # Add permissions
          security_block :foreman_x509 do
            permission :view_foreman_x509_certificates, { :certificates => [:index, :show, :certificate, :key] }
            permission :create_foreman_x509_certificates, { :certificates => [:new, :create] }
            permission :destroy_foreman_x509_certificates, { :certificates => [:destroy] }
          end

          # Add a new role called 'Discovery' if it doesn't exist
          role 'ForemanX509', [:view_foreman_x509]

          # add menu entry
          #sub_menu :top_menu, :plugin_template, icon: 'pficon pficon-enterprise', caption: N_('Plugin Template'), after: :hosts_menu do
          #  menu :top_menu, :welcome, caption: N_('Welcome Page'), engine: ForemanX509::Engine
          #  menu :top_menu, :new_action, caption: N_('New Action'), engine: ForemanX509::Engine
          #end

          # add dashboard widget
          # widget 'foreman_x509_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
        end
      end
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
    'foreman_patch_'
  end


  def self.use_relative_model_naming
    true
  end
end
