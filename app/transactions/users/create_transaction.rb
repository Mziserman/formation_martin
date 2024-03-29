# frozen_string_literal: true

class Users::CreateTransaction
  include Dry::Transaction

  step :create
  tee :send_welcome_email

  private

  def create(input)
    input[:user] = User.new(input[:sign_up_params])
    if input[:user].save
      Success(input[:user])
    else
      Failure(input[:user])
    end
  end

  def send_welcome_email(input)
    UserMailer.with(user: input).welcome_email.deliver
  end
end
