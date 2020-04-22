RSpec.describe Contributions::CreateTransaction do
  subject do
    contribution.project = project
    contribution.user = user

    Contributions::CreateTransaction.new.call(
      resource: contribution
    )
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
      VCR.use_cassette('create_mangopay_wallet') do
        resource = build(:project)
        resource.owners << owner

        Projects::CreateTransaction.new.call(resource: resource).success[:resource]
      end
    end

    let(:contribution) { build(:contribution) }

    it 'gets mangopay payin id' do
      VCR.use_cassette('create_mangopay_payin_card_web') do
        subject
      end

      expect(Contribution.last.mangopay_payin_id).to_not eq nil
    end
  end
end
