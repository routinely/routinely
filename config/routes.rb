Rails.application.routes.draw do
  namespace :admin do
    DashboardManifest::DASHBOARDS.each do |dashboard_resource|
      resources dashboard_resource
    end

    resources :groups do
      get :history, on: :member
    end

    root controller: DashboardManifest::ROOT_DASHBOARD, action: :index
  end

  namespace :api do
    resource :calendar, only: [:show]
    resources :events, only: [:create]
  end

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password, controller: "clearance/passwords", only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  resources :routines, only: [:index]

  resources :periodic_routines do
    get :events, on: :member
  end

  resources :dependent_routines do
    get :events, on: :member
  end

  resources :time_based_routines do
    get :events, on: :member
  end

  resources :rule_based_routines do
    get :events, on: :member
  end

  resources :callbacks, only: [:create, :update, :destroy]
  resources :listeners, only: [:create, :update, :destroy]
end
