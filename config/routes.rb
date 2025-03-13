ForemanX509::Engine.routes.draw do
  resources :certificates, except: [:edit] do
    resources :generations, 
    member do
      get :certificate
      get :key
    end
  end
end

Foreman::Application.routes.draw do
  mount ForemanX509::Engine, at: '/foreman_x509'
end
