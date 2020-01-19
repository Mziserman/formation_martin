# frozen_string_literal: true

class Projects::Container
  extend Dry::Container::Mixin

  namespace 'contributions' do
    register 'set_params' do
      ActiveAdmin::SetParams.new
    end

    register 'create' do
      Create.new
    end

    register 'update' do
      Update.new
    end

    register 'add_current_user_to_params' do
      AddCurrentUserToParams.new
    end

    register 'add_project_to_params' do
      AddProjectToParams.new
    end
  end
end
