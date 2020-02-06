# frozen_string_literal: true

describe ContributionsController, type: :controller do
  let(:project) { create :project }
  let(:attributes) { attributes_for :contribution }
  context 'new not logged' do
    subject do
      get :new, params: { project_id: project.id }
    end
    it { should redirect_to root_url }
  end

  context 'create not logged' do
    subject do
      put :create, params: { project_id: project.id }
    end
    it { should redirect_to root_url }
  end

  context 'new logged' do
    login_user
    subject do
      get :new, params: { project_id: project.id }
    end
    it { should render_template :new }
  end

  context 'create logged with params' do
    login_user
    subject do
      put :create, params: { project_id: project.id, contribution: attributes }
    end
    it 'creates a contribution' do
      expect { subject }.to change(Contribution, :count).by(1)
    end
  end
end
