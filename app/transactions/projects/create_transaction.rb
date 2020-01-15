# frozen_string_literal: true

class Projects::CreateTransaction
  include Dry::Transaction(container: Projects::Container)

  step :create, with: 'projects.create'
  step :handle_aasm_event, with: 'projects.handle_aasm_event'
end
