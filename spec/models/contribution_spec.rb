require 'rails_helper'

RSpec.describe Contribution, type: :model do
  subject { build :contribution }

  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should belong_to(:reward).optional }
end
