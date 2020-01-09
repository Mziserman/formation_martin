# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.email }
    password { 0.upto(rand(6..30)).map { |_| rand(33..122).chr }.join }

    trait :with_successful_logins do
      transient do
        successful_login_count { 3 }
      end

      after(:create) do |admin_user, evaluator|
        evaluator.successful_login_count.times do
          admin_user.login_activities.create success: true
        end
      end
    end
  end
end
