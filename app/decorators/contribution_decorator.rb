# frozen_string_literal: true

class ContributionDecorator < ApplicationDecorator
  delegate_all

  def state_class
    state == 'accepted' ? 'success' : 'failure'
  end
end
