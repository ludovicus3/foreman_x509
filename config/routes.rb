ForemanX509::Engine.routes.draw do
  namespace :api do
    scope '(:apiv)', module: :v2, defaults: { apiv: 'v2' }, apiv: /v1|v2/, constraints: ApiConstraints.new(version: 2, default: true) do

      resources :issuers, only: [:index, :create, :show, :update, :destroy]

      resources :certificates, only: [:index, :create, :show, :update, :destroy] do
        resources :generations, only: [:index, :create, :destroy] do
          member do
            post :activate
            get  :certificate
            post :certificate
            get  'request', to: "generations#signing_request"
            get  :key
          end
        end

        member do
          get :certificate
          get 'request', to: "certificates#signing_request"
          get :key
        end
      end
    end
  end

  constraints(id: /[^\/]+/) do
    resources :issuers, only: [:index, :new, :create, :show, :destroy ]

    resources :certificates do
      member do
        get :certificate
        get 'request', to: 'certificate#signing_request'
        get :key
      end
    end

    resources :certificates, as: :owner, only: [] do
      resources :generations, only: [:new, :create, :edit, :update, :destroy] do
        member do
          post :activate
          get  :certificate
          get  'request', to: 'generations#signing_request'
          get  :key
        end
      end
    end
  end
end

Foreman::Application.routes.draw do
  mount ForemanX509::Engine, at: '/foreman_x509'
end
