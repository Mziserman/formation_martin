# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    user = resource_class.new_with_session(sign_up_params, session)
    User::CreateTransaction.new.call(user: user)
  end
end
