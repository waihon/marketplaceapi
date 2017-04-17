require "api_constraints"

Rails.application.routes.draw do
  devise_for :users
  # http://guides.rubyonrails.org/routing.html
  # Rails will automatically map a namespace to a directory matching
  # the name under to controllers folder.
  namespace :api, defaults: { format: :json },
                  constraints: { subdomain: "api" },
                  # Tells Rails to set the starting path for each request
                  # to be root in relation to the subdomain
                  path: "/" do
    scope module: :v1,
          # Handling versioning through headers instead of sub-folder
          constraints: ApiConstraints.new(version: 1, default: true) do
      # We are going to list our resources here
      resources :users, only: [:show, :create, :update, :destroy]
    end
  end
end
