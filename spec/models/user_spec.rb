require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build :user }

  it { should have_many(:login_activities) }
  it { should have_many(:project_ownerships) }
  it { should have_many(:projects) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:birthdate) }

  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
end
