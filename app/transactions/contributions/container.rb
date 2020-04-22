# frozen_string_literal: true

class Contributions::Container
  extend Dry::Container::Mixin

  namespace 'contributions' do
    register 'save' do
      Save.new
    end
  end
end
