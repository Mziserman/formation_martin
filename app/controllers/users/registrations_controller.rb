# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # def create
  #   user_transaction = User::CreateTransaction.new
  #   user_transaction.call(sign_up_params: sign_up_params) do |transaction|
  #     transaction.success do |user|
  #     end

  #     transaction.failure :create do |user|
  #     end

  #     transaction.failure :send_welcome_email do |error|
  #     end
  #   end
  # end
end
