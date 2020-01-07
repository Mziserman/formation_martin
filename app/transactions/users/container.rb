# frozen_string_literal: true

class Users::Container
  extend Dry::Container::Mixin

  namespace 'users' do
    register 'create' do
      Users::Operations::Create.new
    end

    register 'send_welcome_email' do
      Users::Operations::SendWelcomeEmail.new
    end
  end
end
