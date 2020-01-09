FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.email }
    password { 0.upto(rand(6..30)).map { |_| rand(33..122).chr }.join }
  end
end
