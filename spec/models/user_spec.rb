require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build :user }

  it { should have_many(:login_activities) }
  it { should have_many(:contributions) }
  it { should have_many(:rewards) }
  it { should have_many(:contributor_projects).class_name('Project') }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:birthdate) }

  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }

  context 'basic' do
    let(:user) { create :user }

    it "doesn't have mangopay_id" do
      expect(user.mangopay_id).to eq nil
    end

    it 'initializes mangopay' do
      VCR.use_cassette('create_mangopay_user') do
        user.mangopay
      end
      expect(user.mangopay_id).to_not eq nil
    end
  end
end
