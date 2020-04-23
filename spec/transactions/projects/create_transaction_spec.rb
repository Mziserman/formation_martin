# frozen_string_literal: true

RSpec.describe Contributions::CreateTransaction do
  subject do
    project.owners << owner
    Projects::CreateTransaction.new.call(resource: project)
  end

  context 'with valid attributes' do
    let(:owner) do
      admin_user = create(:admin_user)
      VCR.use_cassette('create_mangopay_user') do
        admin_user.mangopay_id
      end
      admin_user
    end

    let(:project) { build(:project) }

    it 'gets mangopay payin id' do
      VCR.use_cassette('create_mangopay_wallet') do
        subject
      end

      expect(Project.last.mangopay_wallet_id).to_not eq nil
    end
    it 'creates a project' do
      VCR.use_cassette('create_mangopay_wallet') do
        expect { subject }.to change { Project.count }.by(1)
      end
    end
  end
end
