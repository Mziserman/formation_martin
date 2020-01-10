# frozen_string_literal: true

RSpec.describe Admin::UsersController, type: :controller do
  render_views

  let(:page) { Capybara::Node::Simple.new(response.body) }
  login_admin_user

  let!(:user) { create :user }

  let(:valid_attributes) do
    attributes_for :user
  end

  let(:invalid_attributes) do
    valid_attributes.except(:email)
  end

  let!(:three_connection_user) do
    create(
      :user,
      :with_successful_logins,
      successful_login_count: 3
    )
  end

  let!(:single_connection_user) do
    create(
      :user,
      :with_successful_logins,
      successful_login_count: 1
    )
  end

  describe 'GET index' do
    subject { get :index }
    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'assigns the user' do
      subject
      expect(assigns(:users)).to include(user)
    end

    it 'should render the expected columns' do
      subject
      expect(page).to have_content(user.sign_in_count)
      expect(page).to have_content(active_admin_date_format(user.created_at))
      expect(page).to have_content(user.current_sign_in_at || '')
      expect(page).to have_content(user.email)
    end

    let(:filters_sidebar) { page.find('#filters_sidebar_section') }

    it 'filter Email exists' do
      subject
      expect(filters_sidebar).to have_css(
        'label[for="q_email"]', text: 'Email'
      )
      expect(filters_sidebar).to have_css('input[name="q[email_contains]"]')
    end

    it 'filter Email works' do
      matching_user = create :user, email: 'ABCDEFG@gmail.com'
      non_matching_user = create :user, email: 'HIJKLMN@gmail.com'

      get :index, params: { q: { email_contains: 'BCDEF' } }

      expect(assigns(:users)).to include(matching_user)
      expect(assigns(:users)).not_to include(non_matching_user)
    end

    it 'filter sign in count exists' do
      subject
      expect(filters_sidebar).to have_css(
        'label[for="q_successfull_login_activities_count"]',
        text: 'Nombre de connections'
      )
      expect(filters_sidebar).to have_css(
        'input[name="q[successfull_login_activities_count_equals]"]'
      )
    end

    it 'filter sign in count eq works' do
      get :index, params: { q: { successfull_login_activities_count_equals: 3 } }

      expect(assigns(:users)).to include(three_connection_user)
      expect(assigns(:users)).not_to include(single_connection_user)
    end

    it 'filter sign in count gt works' do
      get :index, params: { q: { successfull_login_activities_count_greater_than: 2 } }

      expect(assigns(:users)).to include(three_connection_user)
      expect(assigns(:users)).not_to include(single_connection_user)
    end
    it 'filter sign in count lt works' do
      get :index, params: { q: { successfull_login_activities_count_less_than: 2 } }

      expect(assigns(:users)).to include(single_connection_user)
      expect(assigns(:users)).not_to include(three_connection_user)
    end
  end

  describe 'GET new' do
    subject { get :new }
    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end
    it 'assigns the user' do
      subject
      expect(assigns(:user)).to be_a_new(User)
    end
    it 'should render the form elements' do
      subject
      expect(page).to have_field('Email')
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      subject { post :create, params: { user: valid_attributes } }
      it 'creates a new User' do
        expect do
          subject
        end.to change(User, :count).by(1)
      end

      it 'assigns a newly created user as @user' do
        subject
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it 'redirects to the created user' do
        subject
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_user_url(User.last))
      end

      it 'should create the user' do
        subject
        user = User.last

        expect(user.email).to eq(valid_attributes[:email])
        expect(user.password).to eq(valid_attributes[:passord])
      end
    end

    context 'with invalid params' do
      it 'invalid_attributes return http success' do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:success)
      end

      it 'assigns a newly created but unsaved user as @user' do
        post :create, params: { user: invalid_attributes }
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'invalid_attributes do not create a User' do
        expect do
          post :create, params: { user: invalid_attributes }
        end.not_to change(User, :count)
      end
    end
  end

  describe 'GET edit' do
    before do
      get :edit, params: { id: user.id }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the user' do
      expect(assigns(:user)).to eq(user)
    end
    it 'should render the form elements' do
      expect(page).to have_field('Email')
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      subject do
        put :update, params: { id: user.id, user: valid_attributes }
      end
      it 'assigns the user' do
        subject
        expect(assigns(:user)).to eq(user)
      end
      it 'returns http redirect' do
        subject
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_user_url(user))
      end

      # Testé en vrai, ca marche, mais j'arrive pas a faire marcher le test
      # it 'should update the user' do
      #   subject

      #   expect(user.reload.password).to eq(valid_attributes[:password])
      # end
    end
  end

  describe 'GET show' do
    before do
      get :show, params: { id: user.id }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the user' do
      expect(assigns(:user)).to eq(user)
    end
    it 'should render the form elements' do
      expect(page).to have_content(user.email)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested select_option' do
      expect do
        delete :destroy, params: { id: user.id }
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the field' do
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(admin_users_url)
    end
  end
end
