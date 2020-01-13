FactoryBot.define do
  factory :reward do
    name { Faker::Lorem.word }
    blurb { Faker::Lorem.paragraph }
    threshold_in_cents { rand(100..100_000_000) }

    project
  end
end
