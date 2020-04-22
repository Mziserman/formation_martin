# frozen_string_literal: true

RSpec.describe Contributions::CreateTransaction do
  subject do
    Contributions::ValidateTransaction.new.call(resource: contribution)
  end

  context 'with valid attributes' do
    let(:owner) do
      admin_user = create(:admin_user)
      VCR.use_cassette('create_mangopay_user') do
        admin_user.mangopay_id
      end
      admin_user
    end

    let(:user) do
      user = create(:user)
      VCR.use_cassette('create_mangopay_user') do
        user.mangopay_id
      end
      user
    end

    let(:project) do
      resource = build(:project)
      resource.owners << owner

      VCR.use_cassette('create_mangopay_wallet') do
        Projects::CreateTransaction.new.call(
          resource: resource
        ).success[:resource]
      end
    end

    let(:contribution) do
      resource = build(:contribution)
      resource.project = project
      resource.user = user

      VCR.use_cassette('create_mangopay_payin_card_web') do
        Contributions::CreateTransaction.new.call(
          resource: resource
        ).success[:resource]
      end
    end

    it 'creates a contribution' do
      VCR.use_cassette('validate_mangopay_transaction') do
        expect { subject }.to(change { contribution.state })
      end
    end
  end
end
