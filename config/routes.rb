require 'api_constraints'

DssDw::Application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    scope module: :v0, constraints: ApiConstraints.new(version: 0, default: true) do
      resources :courses
    end
    # scope module: :v2, constraints: ApiConstraints.new(version: 2, default: true) do
    #   resources :products
    # end
  end
end
