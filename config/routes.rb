require 'api_constraints'

DssDw::Application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    scope module: :v0, constraints: ApiConstraints.new(version: 0, default: true) do
      resources :courses
      resources :terms
      resources :people
      resources :departments do
        resources :courses
      end
    end
  end
  
  get "/status" => "application#status"
end
