ForemanPluginTemplate::Engine.routes.draw do
  resources :certificates, except: [:edit] do
    member do
      get :certificate
      get :key
    end
  end
end

Foreman::Application.routes.draw do
  mount ForemanPluginTemplate::Engine, at: '/foreman_x509'
end
