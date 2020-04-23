# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  include AuthTrackable

  validates :first_name, :last_name, :birthdate, presence: true

  has_many :contributions, dependent: :nullify
  has_many :rewards, through: :contributions
  has_many :contributor_projects, through: :contributions, source: :project

  def name
    "#{first_name} #{last_name}"
  end

  def amount_contributed_to(project)
    contributions.not_denied.where(project_id: project.id).sum(:amount)
  end

  def mangopay_id
    return super unless super.nil?

    Users::CreateMangopayTransaction.new.call(resource: self)
    super
  end
end
