ForemanX509::Engine.routes.draw do
  resources :certificates, except: [:edit] do
    resources :generations, only: [:index, :create, :show, :destroy] do
      member do
        put :activate
        get :certificate
        get :key
      end
    end

    member do
      get :certificate
      get :key
    end
  end
end

Foreman::Application.routes.draw do
  mount ForemanX509::Engine, at: '/foreman_x509'
end
