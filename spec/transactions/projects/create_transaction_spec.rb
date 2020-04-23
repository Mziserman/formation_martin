# frozen_string_literal: true

RSpec.describe Projects::CreateTransaction do
  subject do
    VCR.use_cassette('create_mangopay_wallet') do
      project.owners << owner
      Projects::CreateTransaction.new.call(resource: project)
    end
  end

  context 'with valid attributes' do
    let(:owner) do
      admin_user = create(:admin_user)
      admin_user.mangopay_id
      admin_user
    end

    let(:project) { build(:project) }

    it 'gets mangopay payin id' do
      subject
      expect(Project.last.mangopay_wallet_id).to_not eq nil
    end
    it 'creates a project' do
      expect { subject }.to change { Project.count }.by(1)
    end
  end
end
