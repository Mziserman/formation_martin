# frozen_string_literal: true

class Projects::UpdateTransaction
  include Dry::Transaction(container: Projects::Container)

  step :clean_shrine_params, with: 'projects.clean_shrine_params'
  step :update, with: 'projects.update'
  step :handle_aasm_event, with: 'projects.handle_aasm_event'
end
