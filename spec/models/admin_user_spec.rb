require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  subject { build :admin_user }

  it { should have_many(:login_activities) }
  it { should have_many(:project_ownerships) }
  it { should have_many(:projects) }

  it { should validate_presence_of(:email) }

  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }

  context 'basic' do
    let(:admin_user) { create :admin_user }

    it "doesn't have mangopay_id" do
      expect(admin_user.mangopay_id).to eq nil
    end

    it 'initializes mangopay' do
      VCR.use_cassette('create_mangopay_user') do
        admin_user.mangopay
      end
      expect(admin_user.mangopay_id).to_not eq nil
    end
  end
end
