require "api_constraints"

Rails.application.routes.draw do
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
      # Accessed via http://api.xxxxxxxx.yyy
      resources :users, only: [:show, :create, :update, :destroy]
    end
  end
  # Due to duplicates in URI pattern, notably "POST /users", priority is
  # given to custom resources.
  # Accessed via http://xxxxxxxx.yyy
  devise_for :users
end
