# frozen_string_literal: true

class Contributions::CreateTransaction
  include Dry::Transaction(container: Projects::Container)

  step :add_current_user_to_params, with: 'projects.add_current_user_to_params'
  step :add_project_to_params, with: 'projects.add_project_to_params'
  step :create, with: 'projects.create'
end
