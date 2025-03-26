Foreman::Plugin.register :foreman_x509 do
  requires_foreman '>= 3.1.1'

  # Add Global files for extending foreman-core components and routes
  # register_global_js_file 'global'

  # Add permissions
  security_block :foreman_x509 do
  #  permission :view_foreman_x509_certificates, { :certificates => [:index, :show, :certificate, :key] }
  #  permission :create_foreman_x509_certificates, { :certificates => [:new, :create] }
  #  permission :destroy_foreman_x509_certificates, { :certificates => [:destroy] }
  end

  # Add a new role called 'Discovery' if it doesn't exist
  #role 'ForemanX509', [:view_foreman_x509]

  # add menu entries
  divider :top_menu, caption: N_('Certificates'), parent: :infrastructure_menu
  menu :top_menu, :issuers,
    caption: N_('Issuers'),
    engine: ForemanX509::Engine,
    parent: :infrastructure_menu,
  menu :top_menu, :certificates,
    caption: N_('Certificates'),
    engine: ForemanX509::Engine,
    parent: :infrastructure_menu

  # add dashboard widget
  # widget 'foreman_x509_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
end