# frozen_string_literal: true

class Contributions::ValidateTransaction
  include Dry::Transaction(container: Contributions::Container)

  step :fetch_mangopay_payin
  step :set_resource_state
  step :save, with: 'contributions.save'

  # step :notify_user_if_changed

  private

  def fetch_mangopay_payin(input)
    input[:mangopay_payin] = MangoPay::PayIn.fetch(input[:resource].mangopay_payin_id)

    Success(input)
  end

  def set_resource_state(input)
    input[:resource].state = case input[:mangopay_payin]['Status']
                             when 'SUCCEEDED'
                               :accepted
                             when 'FAILED'
                               :denied
                             else
                               :processing
                             end

    Success(input)
  end
end
