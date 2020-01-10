FactoryBot.define do
  factory :project do
    name { Faker::Company.name }
    amount_wanted_in_cents { rand(100_000..100_000_000) }
    small_blurb { Faker::Lorem.sentence }
    long_blurb  { Faker::Lorem.paragraph }

    trait :with_owners do
      transient do
        owners do
          1.upto(3).map do |_|
            create :user
          end
        end
      end

      after(:create) do |project, evaluator|
        evaluator.owners.each do |owner|
          project.project_ownerships.create user: owner
        end
      end
    end
  end
end
