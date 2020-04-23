# frozen_string_literal: true

if Rails.env.development?
  include FactoryBot::Syntax::Methods

  create_list :user, 3
  owners = create_list(:admin_user, 3)
  categories = %w[it finance green startup gadget]

  3.times do
    project = build(
      :project,
      :with_rewards
    )
    project.owners = owners.sample(rand(1..3))
    project.category_list.add(*categories.sample(rand(1..3)))

    Projects::CreateTransaction.new.call(resource: project)
  end

  AdminUser.create!(
    email: 'admin@gmail.com',
    password: 'password',
    password_confirmation: 'password',
    first_name: 'Martin',
    last_name: 'Ziserman',
    birthdate: Date.new(1993, 2, 22)
  )
  User.create!(
    email: 'martinziserman@gmail.com',
    password: 'AZERTYUIOP',
    password_confirmation: 'AZERTYUIOP',
    first_name: 'Martin',
    last_name: 'Ziserman',
    birthdate: Date.new(1993, 2, 22)
  )
end
