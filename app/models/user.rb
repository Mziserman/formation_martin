# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable

  devise :omniauthable, omniauth_providers: %i[facebook]

  include AuthTrackable

  validates :first_name, :last_name, :birthdate, presence: true

  has_many :contributions, dependent: :nullify
  has_many :rewards, through: :contributions
  has_many :contributor_projects, -> { distinct },
           through: :contributions, source: :project

  def name
    "#{first_name} #{last_name}"
  end

  def amount_contributed_to(project)
    contributions.accepted.where(project_id: project.id).sum(:amount)
  end

  def rewards_for_project(project)
    Reward.includes(:contributions).where(contributions: { project_id: project.id })
  end

  def mangopay_id
    return super unless super.nil?

    Users::CreateMangopayTransaction.new.call(resource: self)
    super
  end
end
