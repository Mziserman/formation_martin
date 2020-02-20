FactoryBot.define do
  factory :reward do
    name { Faker::Lorem.word }
    blurb { Faker::Lorem.paragraph }
    threshold { rand(100..100_000_000) }

    project

    limited { [true, false].sample }
    total_stock { nil }

    after(:create) do |reward|
      reward.total_stock = rand(1..100) if reward.limited
    end

    trait :with_contributions do
      # raise :todo
    end
  end
end
