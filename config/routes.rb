# frozen_string_literal: true

Rails.application.routes.draw do
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
    registrations: 'users/registrations'
  }

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  root to: 'home#index'
  get 'dashboard', to: 'dashboard#index'
end
