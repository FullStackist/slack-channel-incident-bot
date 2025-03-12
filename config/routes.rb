Rails.application.routes.draw do

  resources :incidents, only: [:index]

  get "installations/create", to: "installations#create"
  get "installations/:id/success", to: "installations#success", as: "installation_success"

  get "incident/list", to: "incident#list"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :command do
    
    post "rootly", to: "rootly#handle_command"

    post "interaction", to: "rootly#handle_interaction"

  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
