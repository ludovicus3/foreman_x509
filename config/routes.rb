ForemanX509::Engine.routes.draw do
  namespace :api do
    scope '(:apiv)', module: :v2, defaults: { apiv: 'v2' }, apiv: /v1|v2/, constraints: ApiConstraints.new(version: 2, default: true) do

      resources :issuers, only: [:index, :create, :show, :update, :destroy]

      resources :requests, only: [:index, :show] do
        member do
          get :download
        end
      end

      resources :certificates, only: [:index, :create, :show, :update, :destroy] do
        resources :generations, only: [:index, :create, :destroy] do
          member do
            post :activate
            get  :certificate
            post :certificate
            get  :key
          end
        end

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

    resources :certificates do
      resources :generations, param: :generation_id, only: [:new, :create, :update, :destroy] do
        member do
          post :activate
          get  :certificate
          post :upload
          get  :key
        end
      end

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
