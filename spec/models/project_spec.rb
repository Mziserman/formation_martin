require 'rails_helper'

RSpec.describe Project, type: :model do
  subject { build :project }

  it { should have_many(:project_ownerships) }
  it { should have_many(:owners).class_name('User') }

  it { should belong_to(:thumbnail).class_name('Photo').optional }
  it { should belong_to(:landscape).class_name('Photo').optional }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:amount_wanted_in_cents) }
end
