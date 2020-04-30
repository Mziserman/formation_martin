# frozen_string_literal: true

class Rewards::Container
  extend Dry::Container::Mixin

  namespace 'rewards' do
    register 'save' do
      Save.new
    end
  end
end
