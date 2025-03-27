ForemanX509::Engine.routes.draw do
  scope :foreman_patch, path: '/foreman_patch' do
    namespace :api do
      scope '(:apiv)', module: :v2, defaults: { apiv: 'v2' }, apiv: /v1|v2/, constraints: ApiConstraints.new(version: 2, default: true) do

        resources :certificates, only: [:index, :create, :show, :update, :destroy] do
        end
      end
    end
  end

  constraints(id: /[^\/]+/) do
    resources :issuers, only: [:index, :new, :create, :show, :destroy ]

    resources :certificates, except: [:edit] do
      resources :generations, only: [:index, :create, :show, :destroy] do
        member do
          put :activate
          get :certificate
          get :signing_request
          get :key
        end
      end

      member do
        get :certificate
        get :signing_request
        get :key
      end
    end
  end
end

Foreman::Application.routes.draw do
  mount ForemanX509::Engine, at: '/foreman_x509'
end
