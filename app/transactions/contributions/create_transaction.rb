# frozen_string_literal: true

class Contributions::CreateTransaction
  include Dry::Transaction(container: Contributions::Container)

  step :create, with: 'contributions.create'
end
