# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development?
  users = 1.upto(3).map do |index|
    User.create!(
      email: "corentin#{index}@gmail.com",
      first_name: 'Martin',
      last_name: 'Ziserman',
      birthdate: 18.years.ago,
      password: 'password',
      password_confirmation: 'password'
    )
  end

  categories = ['it', 'finance', 'green', 'startup', 'gadget']

  projects = 1.upto(3).map do |index|
    project = Project.create!(
      name: "project#{index}",
      amount_wanted_in_cents: (index * 100_000_000),
      small_blurb: 'please',
      long_blurb: 'need money'
    )
    project.category_list.add(categories.sample(rand(1..3)))
    project.save
    project
  end

  projects.each do |project|
    owners = users.sample(rand(1..3))
    project.project_ownerships.create(owners.map do |owner|
      {
        user_id: owner.id
      }
    end)
  end

  AdminUser.create!(email: 'admin@gmail.com', password: 'password', password_confirmation: 'password')
end
