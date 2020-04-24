# frozen_string_literal: true

class Users::ContributorsCsvTransaction
  include Dry::Transaction(container: Users::Container)

  step :get_contributors
  step :generate_csv

  private

  def get_contributors(input)
    input[:contributors] = input[:resource].contributors

    Success(input)
  end

  def generate_csv(input)
    attributes = %w[email first_name last_name amount_contributed]

    csv = CSV.generate(headers: true) do |csv|
      csv << attributes

      input[:contributors].each do |user|
        csv << row(user, input[:resource])
      end
    end

    Success(csv)
  end

  def row(user, project)
    attributes = %w[email first_name last_name]
    row = attributes.map { |attr| user.send(attr) }
    row << ApplicationController.helpers.currency_print(
      user.amount_contributed_to(project)
    )
    row
  end
end
