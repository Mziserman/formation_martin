# frozen_string_literal: true

class Contributions::CreateTransaction
  include Dry::Transaction(container: Contributions::Container)

  step :add_current_user_to_params, with: 'contributions.add_current_user_to_params'
  step :add_project_to_params, with: 'contributions.add_project_to_params'
  step :create, with: 'contributions.create'
end
