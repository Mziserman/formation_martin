# frozen_string_literal: true

RSpec.describe Projects::CreateTransaction do
  subject do
    VCR.use_cassette('create_mangopay_wallet') do
      Projects::CreateTransaction.new.call(resource: project)
    end
  end

  context 'with valid attributes' do
    let(:owner) do
      create(:admin_user)
    end

    let(:project) { build(:project, :with_owner, owner: owner) }

    it 'gets mangopay payin id' do
      subject
      expect(Project.last.mangopay_wallet_id).to_not eq nil
    end
    it 'creates a project' do
      expect { subject }.to change { Project.count }.by(1)
    end
  end
end
