class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  include AuthTrackable

  has_many :project_ownerships, dependent: :destroy
  has_many :projects, through: :project_ownerships

  def mangopay
    if mangopay_id.nil?
      create_mangopay
    else
      fetch_mangopay
    end
  end

  def create_mangopay
    mangopay_user = MangoPay::NaturalUser.create(
      Email: email,
      FirstName: first_name,
      LastName: last_name,
      Nationality: 'FR',
      CountryOfResidence: 'FR',
      Birthday: birthdate.to_time.to_i
    )

    update(mangopay_id: mangopay_user['id'])
    mangopay_user
  end

  def fetch_mangopay
    MangoPay::NaturalUser.fetch(mangopay_id)
  end
end
