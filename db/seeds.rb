# frozen_string_literal: true

if Rails.env.development?
  include FactoryBot::Syntax::Methods

  users = 1.upto(3).map do |_index|
    create :user
  end

  categories = %w[it finance green startup gadget]

  1.upto(3).map do |_index|
    create(
      :project,
      :with_owners,
      :with_categories,
      owners: users.sample(rand(1..3)),
      categories: categories.sample(rand(1..3))
    )
  end

  AdminUser.create!(email: 'admin@gmail.com', password: 'password', password_confirmation: 'password')
end
