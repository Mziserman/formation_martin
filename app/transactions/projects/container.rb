# frozen_string_literal: true

class Projects::Container
  extend Dry::Container::Mixin

  namespace 'projects' do
    register 'create' do
      Create.new
    end

    register 'save' do
      Save.new
    end

    register 'handle_aasm_event' do
      ActiveAdmin::HandleAasmEvent.new
    end
  end
end
