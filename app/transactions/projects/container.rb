# frozen_string_literal: true

class Projects::Container
  extend Dry::Container::Mixin

  namespace 'projects' do
    register 'set_params' do
      ActiveAdmin::SetParams.new
    end

    register 'create' do
      Create.new
    end

    register 'update' do
      Update.new
    end

    register 'handle_aasm_event' do
      ActiveAdmin::HandleAasmEvent.new
    end

    register 'clean_shrine_params' do
      ActiveAdmin::CleanShrineParams.new
    end
  end
end
