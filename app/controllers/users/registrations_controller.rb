# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    user_transaction = Users::CreateTransaction.new
    user_transaction.call(sign_up_params: sign_up_params) do |transaction|
      transaction.success do |user|
        sign_in(user)
        redirect_to root_path
      end

      transaction.failure do |user|
        user.password = ''
        user.password_confirmation = ''
        render :new, locals: { resource: user }
      end
    end
  end
end
