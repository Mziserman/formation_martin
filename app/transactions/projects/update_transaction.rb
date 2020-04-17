# frozen_string_literal: true

class Projects::UpdateTransaction
  include Dry::Transaction(container: Projects::Container)

  step :update, with: 'projects.update'
  step :handle_aasm_event, with: 'projects.handle_aasm_event'
end
