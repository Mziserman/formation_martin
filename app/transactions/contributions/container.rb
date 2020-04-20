# frozen_string_literal: true

class Contributions::Container
  extend Dry::Container::Mixin

  namespace 'contributions' do
    register 'create' do
      Create.new
    end
  end
end
