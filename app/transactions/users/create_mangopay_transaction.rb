# frozen_string_literal: true

class Users::CreateMangopayTransaction
  include Dry::Transaction(container: Users::Container)

  step :post_mangopay_user
  step :save_id

  private

  def post_mangopay_user(input)
    input[:mangopay_response] = MangoPay::NaturalUser.create(
      Email: input[:resource].email,
      FirstName: input[:resource].first_name,
      LastName: input[:resource].last_name,
      Nationality: 'FR',
      CountryOfResidence: 'FR',
      Birthday: input[:resource].birthdate.to_time.to_i
    )

    Success(input)
  end

  def save_id(input)
    input[:resource].update(mangopay_id: input[:mangopay_response]['Id'])

    Success(input)
  end
end
