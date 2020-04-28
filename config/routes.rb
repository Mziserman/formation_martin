# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options host: ENV['ROOT_URL']

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # https://github.com/activeadmin/activeadmin/issues/221#issuecomment-10757256
  namespace :admin do
    resources :users do
      resources :login_activities
    end
    resources :admin_users do
      resources :login_activities
    end
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  get 'me', to: 'users#show'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  root to: 'home#index'
  get 'dashboard', to: 'dashboard#index'
  resources :projects, only: %i[show index] do
    resources :contributions, only: %i[new create show]
    get 'contributions/validate', to: 'contributions#validate'
  end
end
