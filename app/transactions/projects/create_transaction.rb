# frozen_string_literal: true

class Projects::CreateTransaction
  include Dry::Transaction(container: Projects::Container)

  step :create, with: 'projects.create'
end
