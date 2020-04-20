# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contribution, type: :model do
  subject { create :contribution }

  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should belong_to(:reward).optional.counter_cache(true) }

  context 'with amount contributed below reward threshold' do
    subject do
      create(
        :contribution,
        project: project,
        amount: project.rewards.first.threshold - 1,
        reward: project.rewards.first
      )
    end
    let(:project) { create :project, :with_rewards }

    it 'can\'t donate' do
      expect { subject }.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
