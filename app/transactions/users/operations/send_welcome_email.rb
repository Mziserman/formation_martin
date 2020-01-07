# frozen_string_literal: true

require 'dry/transaction/operation'

class Users::Operations::SendWelcomeEmail
  include Dry::Transaction::Operation

  def call(input)
    UserMailer.with(input[:user]).welcome_email.deliver
    Success(input[:user])
  rescue StandardError => e
    Failure(e)
  end
end
