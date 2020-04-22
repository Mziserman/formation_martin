# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    resource = User.new(sign_up_params)
    user_transaction = Users::CreateTransaction.new
    user_transaction.call(resource: resource) do |transaction|
      transaction.success do |output|
        sign_in(output[:resource])
        redirect_to root_path
      end

      transaction.failure do |output|
        clean_up_passwords(output[:resource])
        render :new, locals: { resource: output[:resource] }
      end
    end
  end
end
