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
    admin_user
  end
  let(:project) do
    resource = build(:project)
    resource.owners << owner

    resource
  end

  let(:attributes) { attributes_for(:contribution, amount: rand(100..100_000_000)) }

  subject do
    VCR.use_cassette('create_mangopay_payin_card_web', allow_playback_repeats: true) do
      Projects::CreateTransaction.new.call(resource: project)

      put :create, params: { project_id: project.id, contribution: attributes }
    end
  end

  context 'create logged with params' do
    login_user
    it 'creates a contribution' do
      expect { subject }.to change(Contribution, :count).by(1)
    end
  end

  context 'create not logged' do
    it { should redirect_to root_url }
  end
end
