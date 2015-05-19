Rails.application.routes.draw do
  resources :payloads, only: [ :create ]
end
