require 'rails_helper'

RSpec.describe Reward, type: :model do
  subject { build :reward }

  it { should belong_to(:project) }
end
