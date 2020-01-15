# frozen_string_literal: true

require 'dry/transaction/operation'

class Projects::Operations::HandleAasmEvent
  include Dry::Transaction::Operation

  def call(input)
    event = input[:params][:project][:active_admin_requested_event]
    return Right(input) unless event.present?

    safe_event = (
      project.aasm.events(permitted: true).map(&:name) & [event.to_sym]
    ).first

    if !safe_event
      raise "Forbidden event #{event} requested on instance #{project.id}"
    end

    project.send("#{safe_event}!")
  end
end
