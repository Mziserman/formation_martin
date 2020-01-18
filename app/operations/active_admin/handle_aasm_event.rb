# frozen_string_literal: true

require 'dry/transaction/operation'

class ActiveAdmin::HandleAasmEvent
  include Dry::Transaction::Operation

  def call(input)
    event = input[:params][:active_admin_requested_event]
    return Success(input) unless event.present?

    safe_event = (
      input[:resource].aasm.events(permitted: true).map(&:name) & [event.to_sym]
    ).first

    if !safe_event
      return Failure(input)
    end

    result = input[:resource].send("#{safe_event}!")

    result ? Success(input) : Failure(input)
  end
end
