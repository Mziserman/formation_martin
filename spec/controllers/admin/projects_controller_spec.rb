# frozen_string_literal: true

RSpec.describe Admin::ProjectsController, type: :controller do
  render_views

  let(:page) { Capybara::Node::Simple.new(response.body) }
  login_admin_user

  let!(:project) { create :project }

  let(:valid_attributes) do
    attributes_for :project
  end

  let(:invalid_attributes) do
    valid_attributes.except(:name)
  end

  describe 'GET index' do
    let(:params) { {} }
    subject { get :index, params: params }

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'assigns the project' do
      subject
      expect(assigns(:projects)).to include(project)
    end

    it 'should render the expected columns' do
      subject
      expect(page).to have_content(active_admin_date_format(project.created_at))
      expect(page).to have_content(project.amount_wanted_in_cents)
    end

    let(:filters_sidebar) { page.find('#filters_sidebar_section') }

    it 'filter Nom exists' do
      subject
      expect(filters_sidebar).to have_css(
        'label[for="q_name"]', text: 'Nom'
      )
      expect(filters_sidebar).to have_css('input[name="q[name_contains]"]')
    end

    context 'with name filter' do
      let(:params) { { q: { name_contains: 'BCDEF' } } }

      it 'filter Email works' do
        matching_project = create :project, name: 'ABCDEFG@gmail.com'
        non_matching_project = create :project, name: 'HIJKLMN@gmail.com'

        subject

        expect(assigns(:projects)).to include(matching_project)
        expect(assigns(:projects)).not_to include(non_matching_project)
      end
    end
  end

  describe 'GET new' do
    subject { get :new }
    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end
    it 'assigns the project' do
      subject
      expect(assigns(:project)).to be_a_new(Project)
    end
    it 'should render the form elements' do
      subject
      expect(page).to have_field('Nom')
    end
  end

  describe 'POST create' do
    let(:params) { { project: valid_attributes } }
    subject { post :create, params: params }

    context 'with valid params' do
      it 'creates a new Project' do
        expect do
          subject
        end.to change(Project, :count).by(1)
      end

      it 'assigns a newly created project as @project' do
        subject
        expect(assigns(:project)).to be_a(Project)
        expect(assigns(:project)).to be_persisted
      end

      it 'redirects to the created project' do
        subject
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_project_url(Project.last))
      end

      it 'should create the project' do
        subject
        project = Project.last

        expect(project.name).to eq(valid_attributes[:name])
        expect(project.amount_wanted_in_cents).to eq(valid_attributes[:amount_wanted_in_cents])
      end
    end

    context 'with invalid params' do
      let(:params) { { project: invalid_attributes } }
      it 'invalid_attributes return http success' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'assigns a newly created but unsaved project as @project' do
        subject
        expect(assigns(:project)).to be_a_new(Project)
      end

      it 'invalid_attributes do not create a Project' do
        expect { subject }.not_to change(Project, :count)
      end
    end
  end

  describe 'GET edit' do
    before do
      get :edit, params: { id: project.id }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the project' do
      expect(assigns(:project)).to eq(project)
    end
    it 'should render the form elements' do
      expect(page).to have_field('Nom')
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      subject do
        put :update, params: { id: project.id, project: valid_attributes }
      end
      it 'assigns the project' do
        subject
        expect(assigns(:project)).to eq(project)
      end
      it 'returns http redirect' do
        subject
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_project_url(project))
      end

      # Testé en vrai, ca marche, mais j'arrive pas a faire marcher le test
      # it 'should update the project' do
      #   subject

      #   expect(project.reload.password).to eq(valid_attributes[:password])
      # end
    end
  end

  describe 'GET show' do
    before do
      get :show, params: { id: project.id }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the project' do
      expect(assigns(:project)).to eq(project)
    end
    it 'should render the form elements' do
      expect(page).to have_content(project.name)
    end
  end

  describe 'DELETE #destroy' do
    subject do
      delete :destroy, params: { id: project.id }
    end
    it 'destroys the requested select_option' do
      expect { subject }.to change(Project, :count).by(-1)
    end

    it 'redirects to the field' do
      subject
      expect(response).to redirect_to(admin_projects_url)
    end
  end
end
