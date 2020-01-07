FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 0.upto(rand(6..30)).map { |_| rand(33, 122).chr }.join }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    birthdate  { Faker::Date.birthday(min_age: 6, max_age: 85)  }
  end
end
