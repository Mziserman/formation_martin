# frozen_string_literal: true

if Rails.env.development?
  include FactoryBot::Syntax::Methods

  users = 1.upto(3).map do |_index|
    create :user
  end

  owners = 1.upto(3).map do |_index|
    create :admin_user
  end
  categories = %w[it finance green startup gadget]

  1.upto(3).map do |_index|
    create(
      :project,
      :with_owners,
      :with_categories,
      :with_rewards,
      owners: owners.sample(rand(1..3)),
      categories: categories.sample(rand(1..3))
    )
  end

  AdminUser.create!(
    email: 'admin@gmail.com',
    password: 'password',
    password_confirmation: 'password',
    first_name: 'Martin',
    last_name: 'Ziserman',
    birthdate: Date.new(1993, 2, 22)
  )
end
