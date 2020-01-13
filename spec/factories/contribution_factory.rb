FactoryBot.define do
  factory :contribution do
    amount_donated_in_cents { rand(100..100_000_000) }

    project
    user

    trait :with_reward do
      transient do
        reward { create :reward }
      end

      after(:create) do |contribution, evaluator|
        contribution.update(reward: evaluator.reward)
      end
    end
  end
end
