require 'rails_helper'

RSpec.describe ProjectOwnership, type: :model do
  subject { build :project_ownership }

  it { should belong_to(:project) }
  it { should belong_to(:admin_user) }

  it { should validate_uniqueness_of(:admin_user_id).scoped_to(:project_id) }
end
