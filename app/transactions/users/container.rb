# frozen_string_literal: true

class Users::Container
  extend Dry::Container::Mixin

  namespace 'users' do
    register 'save' do
      Save.new
    end
  end
end
