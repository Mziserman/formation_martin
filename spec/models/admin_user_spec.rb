require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  subject { build :admin_user }

  it { should have_many(:login_activities) }

  it { should validate_presence_of(:email) }

  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
end
