# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  root to: 'application#index'
end
