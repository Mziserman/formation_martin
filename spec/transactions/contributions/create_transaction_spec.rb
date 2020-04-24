# frozen_string_literal: true

RSpec.describe Contributions::CreateTransaction do
  subject do
    VCR.use_cassette('create_mangopay_payin_card_web', allow_playback_repeats: true) do
      Projects::CreateTransaction.new.call(resource: project).success[:resource]

      Contributions::CreateTransaction.new.call(
        resource: contribution
      )
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
      build(:project, :with_owner, owner: owner)
    end

    let(:contribution) do
      build(:contribution, :with_project, :with_user,
            project: project, user: user)
    end

    it 'gets mangopay payin id' do
      subject

      expect(Contribution.last.mangopay_payin_id).to_not eq nil
    end

    it 'creates a contribution' do
      expect { subject }.to change { Contribution.count }.by(1)
    end
  end
end
