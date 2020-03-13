# frozen_string_literal: true

class Projects::Container
  extend Dry::Container::Mixin

  namespace 'projects' do
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
      ActiveAdmin::Projects::CleanShrineParams.new
    end
  end
end
