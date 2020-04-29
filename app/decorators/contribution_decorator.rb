# frozen_string_literal: true

class ContributionDecorator < ApplicationDecorator
  delegate_all

  def state_class
    case state
    when 'accepted'
      'success'
    when 'denied'
      'failure'
    else
      'processing'
    end
  end
end
