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
        project = build(:project)
        project.owners << owner
        project
      end

      let(:contribution) do
        resource = build(:contribution)
        resource.project = project
        resource.user = user
        resource
      end

      it 'validates a contribution' do
        expect { subject }.to(change { contribution.state })
      end
    end
  end
