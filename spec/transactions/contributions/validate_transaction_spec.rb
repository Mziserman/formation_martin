# frozen_string_literal: true

RSpec.describe Contributions::CreateTransaction do
  subject do
    VCR.use_cassette('validate_mangopay_transaction') do
      Projects::CreateTransaction.new.call(
        resource: project
      ).success[:resource]

      Contributions::CreateTransaction.new.call(
        resource: contribution
      ).success[:resource]

      Contributions::ValidateTransaction.new.call(resource: contribution)
    end
  end

  context 'with valid attributes' do
    let(:owner) do
      create(:admin_user)
    end

    let(:user) do
      create(:user)
    end

    let(:project) do
      build(:project, :with_owner)
    end

    let(:contribution) do
      build(:contribution, :with_project, :with_user,
            project: project, user: user)
    end

    it 'validates a contribution' do
      expect { subject }.to(change { contribution.state })
    end
  end
end
