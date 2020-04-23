# frozen_string_literal: true

describe ContributionsController, '#new', type: :controller do
  let(:project) { create :project }
  let(:attributes) { attributes_for :contribution }

  subject do
    get :new, params: { project_id: project.id }
  end

  context 'new not logged' do
    it { should redirect_to root_url }
  end

  context 'new logged' do
    login_user
    it { should render_template :new }
  end
end

describe ContributionsController, '#create', type: :controller do
  let(:owner) do
    admin_user = create(:admin_user)
    VCR.use_cassette('create_mangopay_user') do
      admin_user.mangopay_id
    end
    admin_user
  end
  let(:project) do
    VCR.use_cassette('create_mangopay_wallet') do
      resource = build(:project)
      resource.owners << owner

      Projects::CreateTransaction.new.call(resource: resource).success[:resource]
    end
  end

  let(:attributes) { attributes_for(:contribution, amount: rand(100..100_000_000)) }

  subject do
    put :create, params: { project_id: project.id, contribution: attributes }
  end

  context 'create not logged' do
    it { should redirect_to root_url }
  end

  context 'create logged with params' do
    login_user
    it 'creates a contribution' do
      VCR.use_cassette('create_mangopay_payin_card_web') do
        expect { subject }.to change(Contribution, :count).by(1)
      end
    end
  end
end
