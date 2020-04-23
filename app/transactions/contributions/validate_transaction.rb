# frozen_string_literal: true

class Contributions::ValidateTransaction
  include Dry::Transaction(container: Contributions::Container)

  step :fetch_mangopay_payin
  step :set_resource_state
  step :save, with: 'contributions.save'

  private

  def fetch_mangopay_payin(input)
    input[:mangopay_payin] = MangoPay::PayIn.fetch(input[:resource].mangopay_payin_id)

    Success(input)
  end

  def set_resource_state(input)
    input[:resource].state = input[:mangopay_payin]['Status'] == 'SUCCEEDED' ? :accepted : :denied

    Success(input)
  end
end
