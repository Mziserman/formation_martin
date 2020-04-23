# frozen_string_literal: true

FactoryBot.define do
  factory :contribution do
    project
    user
    amount { rand(100..10_000) }

    after(:build) do |contribution|
      contribution.project = create :project unless contribution.project.nil?
      contribution.user = create :user unless contribution.user.nil?

      if contribution.reward.present? && !contribution.amount.present?
        contribution.amount = contribution.reward.threshold + rand(10_000)
      end
    end
  end
end
