FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 0.upto(rand(6..30)).map { |_| rand(33..122).chr }.join }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    birthdate  { Faker::Date.birthday(min_age: 6, max_age: 85) }

    trait :with_successful_logins do
      transient do
        successful_login_count { 3 }
      end

      after(:create) do |user, evaluator|
        evaluator.successful_login_count.times do
          user.login_activities.create success: true
        end
      end
    end
  end
end
