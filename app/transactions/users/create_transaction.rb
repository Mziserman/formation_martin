# frozen_string_literal: true

class Users::CreateTransaction
  include Dry::Transaction(container: Users::Container)

  step :save, with: 'users.save'
  tee :send_welcome_email

  private

  def send_welcome_email(input)
    UserMailer.with(user: input[:resource]).welcome_email.deliver
  end
end
