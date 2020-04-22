class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  include AuthTrackable

  has_many :project_ownerships, dependent: :destroy
  has_many :projects, through: :project_ownerships

  def mangopay_id
    return super unless super.nil?

    Users::CreateMangopayTransaction.new.call(resource: self)
    super
  end
end
