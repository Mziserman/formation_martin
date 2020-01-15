# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { Faker::Company.name }
    amount_wanted { rand(100_000..100_000_000) }
    small_blurb { Faker::Lorem.sentence }
    long_blurb  { Faker::Lorem.paragraph }

    trait :with_thumbnail do
      thumbnail { File.new("#{Rails.root}/spec/support/files/image.png") }
    end

    trait :with_landscape do
      landscape { File.new("#{Rails.root}/spec/support/files/image.png") }
    end

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

    trait :with_rewards do
      transient do
        rewards do
          1.upto(3).map do |_|
            attributes_for(:reward).tap do |reward|
              reward[:threshold] = nil
            end
          end
        end
      end

      after(:create) do |project, evaluator|
        thresholds = [0.01, 0.05, 0.1, 0.15, 0.2, 0.3, 0.5]
        evaluator.rewards.each_with_index do |reward, index|
          r = reward.tap do |reward_hsh|
            reward_hsh[:stock] = rand(1..100) if reward_hsh[:limited]
            if reward_hsh[:threshold].nil?
              reward_hsh[:threshold] = project.amount_wanted * thresholds[index]
            end
          end

          project.rewards.create r
        end
      end
    end

    trait :with_contributions do
      transient do
        contributions do
          1.upto(3).map do |_|
            attributes_for(:contribution)
          end
        end
      end

      after(:create) do |project, evaluator|
        evaluator.contributions.each do |contribution|
          project.contributions.create contribution
        end
      end
    end

    trait :with_categories do
      transient do
        categories { %w[it company tech] }
      end

      after(:create) do |project, evaluator|
        evaluator.categories.each do |category|
          project.category_list.add(category)
        end
        project.save
      end
    end
  end
end
