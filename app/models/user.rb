# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  include AuthTrackable

  validates :first_name, :last_name, :birthdate, presence: true

  def name
    "#{first_name} #{last_name}"
  end

  # ransacker :sign_in_count do
  #   Arel.sql("(
  #     SELECT COUNT(id)
  #     FROM login_activities
  #     WHERE login_activities.user_id = users.id
  #     AND login_activities.user_type = User
  #   )")
  # end
end
