# frozen_string_literal: true

class Projects::Container
  extend Dry::Container::Mixin

  namespace 'projects' do
    register 'create' do
      Projects::Operations::Create.new
    end

    register 'update' do
      Projects::Operations::Update.new
    end

    register 'handle_aasm_event' do
      Projects::Operations::HandleAasmEvent.new
    end
  end
end
