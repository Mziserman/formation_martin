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

    trait :with_project do
      transient do
        project do
          create(:project)
        end
      end

      after(:build) do |contribution, evaluator|
        contribution.project = evaluator.project
      end
    end

    trait :with_user do
      transient do
        user do
          create(:user)
        end
      end

      after(:build) do |contribution, evaluator|
        contribution.user = evaluator.user
      end
    end
  end
end
