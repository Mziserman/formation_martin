# frozen_string_literal: true

class Projects::CreateTransaction
  include Dry::Transaction(container: Projects::Container)

  step :set_params, with: 'projects.set_params'
  step :clean_shrine_params, with: 'projects.clean_shrine_params'
  step :create, with: 'projects.create'
end