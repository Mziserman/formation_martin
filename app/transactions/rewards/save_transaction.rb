# frozen_string_literal: true

class Rewards::SaveTransaction
  include Dry::Transaction(container: Rewards::Container)

  step :save, with: 'rewards.save'
end
