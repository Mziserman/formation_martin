# frozen_string_literal: true

class Users::Container
  extend Dry::Container::Mixin

  namespace 'users' do
    register 'create' do
      Create.new
    end
  end
end
