FactoryBot.define do
  factory :contribution do
    amount_donated_in_cents { rand(100..100_000_000) }

    project
    user
  end
end
