ForemanX509::Engine.routes.draw do
  namespace :api do
    scope '(:apiv)', module: :v2, defaults: { apiv: 'v2' }, apiv: /v1|v2/, constraints: ApiConstraints.new(version: 2, default: true) do

      resources :issuers, only: [:index, :create, :show, :update, :destroy]

      resources :requests, only: [:index, :show] do
        member do
          get :download
        end
      end

      resources :certificates, only: [], param: :owner_id do
        member do
          resources :generations, only: [:index, :create, :update, :destroy] do
            member do
              get :certificate
              get :key
            end
          end
        end
      end

      resources :certificates, only: [:index, :create, :show, :update, :destroy] do
        member do
          get :certificate
          get :key
        end
      end
    end
  end

  constraints(id: /[^\/]+/) do
    resources :issuers, only: [:index, :new, :create, :show, :destroy ]

    resources :requests, only: [:show]

    constraints(owner_id: /[^\/]+/) do
      resources :certificates, only: [], param: :owner_id do
        member do
          resources :generations, only: [:new, :create, :update, :destroy] do
            member do
              get  :certificate
              get  :key
            end
          end
        end
      end
    end
    
    resources :certificates do
      member do
        get :certificate
        get :key
      end
    end
  end
end

Foreman::Application.routes.draw do
  mount ForemanX509::Engine, at: '/foreman_x509'
end
