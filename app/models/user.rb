# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  include AuthTrackable

  validates :first_name, :last_name, :birthdate, presence: true

  has_many :project_ownerships, dependent: :destroy
  has_many :projects, through: :project_ownerships

  has_many :contributions, dependent: :nullify
  has_many :rewards, through: :contributions
  has_many :contributor_projects, through: :contributions, source: :project

  def name
    "#{first_name} #{last_name}"
  end

  def amount_contributed_to(project)
    contributions.where(project_id: project.id).sum(amount)
  end
end
