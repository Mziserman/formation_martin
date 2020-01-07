# frozen_string_literal: true

class Users::CreateTransaction
  include Dry::Transaction(container: Users::Container)

  step :create, with: 'users.create'
  step :send_welcome_email, with: 'users.send_welcome_email'
end
