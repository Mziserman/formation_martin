# frozen_string_literal: true

class Projects::SaveTransaction
  include Dry::Transaction(container: Projects::Container)

  step :save, with: 'projects.save'
  step :handle_aasm_event, with: 'projects.handle_aasm_event'
end
