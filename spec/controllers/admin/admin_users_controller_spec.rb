# frozen_string_literal: true

RSpec.describe Admin::AdminUsersController, type: :controller do
  render_views

  let(:page) { Capybara::Node::Simple.new(response.body) }
  login_admin_user

  let!(:admin_user) { create :admin_user }

  let(:valid_attributes) do
    attributes_for :admin_user
  end

  let(:invalid_attributes) do
    valid_attributes.except(:email)
  end

  describe 'GET index' do
    subject { get :index }
    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'assigns the admin_user' do
      subject
      expect(assigns(:admin_users)).to include(admin_user)
    end

    it 'should render the expected columns' do
      subject
      expect(page).to have_content(admin_user.sign_in_count)
      expect(page).to have_content(active_admin_date_format(admin_user.created_at))
      expect(page).to have_content(admin_user.current_sign_in_at || '')
      expect(page).to have_content(admin_user.email)
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
      matching_person = create :admin_user, email: 'ABCDEFG@gmail.com'
      non_matching_person = create :admin_user, email: 'HIJKLMN@gmail.com'

      get :index, params: { q: { email_contains: 'BCDEF' } }

      expect(assigns(:admin_users)).to include(matching_person)
      expect(assigns(:admin_users)).not_to include(non_matching_person)
    end

    it 'filter sign in count exists' do
      subject
      expect(filters_sidebar).to have_css(
        'label[for="q_successfull_login_activities_count"]',
        text: 'Successfull login activities count'
      )
      expect(filters_sidebar).to have_css(
        'input[name="q[successfull_login_activities_count_equals]"]'
      )
    end

    let!(:three_connection_admin) do
      create(
        :admin_user,
        :with_successful_logins,
        successful_login_count: 3
      )
    end

    let!(:single_connection_admin) do
      create(
        :admin_user,
        :with_successful_logins,
        successful_login_count: 1
      )
    end

    it 'filter sign in count eq works' do
      get :index, params: { q: { successfull_login_activities_count_equals: 3 } }

      expect(assigns(:admin_users)).to include(three_connection_admin)
      expect(assigns(:admin_users)).not_to include(single_connection_admin)
    end

    it 'filter sign in count gt works' do
      get :index, params: { q: { successfull_login_activities_count_greater_than: 2 } }

      expect(assigns(:admin_users)).to include(three_connection_admin)
      expect(assigns(:admin_users)).not_to include(single_connection_admin)
    end
    it 'filter sign in count lt works' do
      get :index, params: { q: { successfull_login_activities_count_less_than: 2 } }

      expect(assigns(:admin_users)).to include(single_connection_admin)
      expect(assigns(:admin_users)).not_to include(three_connection_admin)
    end
  end

  # describe "GET new" do
  #   it 'returns http success' do
  #     get :new
  #     expect(response).to have_http_status(:success)
  #   end
  #   it 'assigns the person' do
  #     get :new
  #     expect(assigns(:person)).to be_a_new(Person)
  #   end
  #   it "should render the form elements" do
  #     get :new
  #     expect(page).to have_field('First name')
  #     expect(page).to have_field('Last name')
  #     expect(page).to have_field('Email')
  #   end
  # end

  # describe "POST create" do
  #   context "with valid params" do
  #     it "creates a new Person" do
  #       expect {
  #         post :create, params: { person: valid_attributes }
  #       }.to change(Person, :count).by(1)
  #     end

  #     it "assigns a newly created person as @person" do
  #       post :create, params: { person: valid_attributes }
  #       expect(assigns(:person)).to be_a(Person)
  #       expect(assigns(:person)).to be_persisted
  #     end

  #     it "redirects to the created person" do
  #       post :create, params: { person: valid_attributes }
  #       expect(response).to have_http_status(:redirect)
  #       expect(response).to redirect_to(admin_person_path(Person.last))
  #     end

  #     it 'should create the person' do
  #       post :create, params: { person: valid_attributes }
  #       person = Person.last

  #       expect(person.first_name).to eq(valid_attributes[:first_name])
  #       expect(person.last_name).to  eq(valid_attributes[:last_name])
  #       expect(person.email).to      eq(valid_attributes[:email])
  #     end
  #   end

  #   context "with invalid params" do
  #     it 'invalid_attributes return http success' do
  #       post :create, params: { person: invalid_attributes }
  #       expect(response).to have_http_status(:success)
  #     end

  #     it "assigns a newly created but unsaved person as @person" do
  #       post :create, params: { person: invalid_attributes }
  #       expect(assigns(:person)).to be_a_new(Person)
  #     end

  #     it 'invalid_attributes do not create a Person' do
  #       expect do
  #         post :create, params: { person: invalid_attributes }
  #       end.not_to change(Person, :count)
  #     end
  #   end
  # end

  # describe "GET edit" do
  #   before do
  #     get :edit, params: { id: person.id }
  #   end
  #   it 'returns http success' do
  #     expect(response).to have_http_status(:success)
  #   end
  #   it 'assigns the person' do
  #     expect(assigns(:person)).to eq(person)
  #   end
  #   it "should render the form elements" do
  #     expect(page).to have_field('First name', with: person.first_name)
  #     expect(page).to have_field('Last name', with: person.last_name)
  #     expect(page).to have_field('Email', with: person.email)
  #   end
  # end

  # describe "PUT update" do
  #   context 'with valid params' do
  #     before do
  #       put :update, params: { id: person.id, person: valid_attributes }
  #     end
  #     it 'assigns the person' do
  #       expect(assigns(:person)).to eq(person)
  #     end
  #     it 'returns http redirect' do
  #       expect(response).to have_http_status(:redirect)
  #       expect(response).to redirect_to(admin_person_path(person))
  #     end
  #     it "should update the person" do
  #       person.reload

  #       expect(person.last_name).to  eq(valid_attributes[:last_name])
  #       expect(person.first_name).to eq(valid_attributes[:first_name])
  #       expect(person.email).to      eq(valid_attributes[:email])
  #     end
  #   end
  #   context 'with invalid params' do
  #     it 'returns http success' do
  #       put :update, params: { id: person.id, person: invalid_attributes }
  #       expect(response).to have_http_status(:success)
  #     end
  #     it 'does not change person' do
  #       expect do
  #         put :update, params: { id: person.id, person: invalid_attributes }
  #       end.not_to change { person.reload.first_name }
  #     end
  #   end
  # end

  # describe "GET show" do
  #   before do
  #     get :show, params: { id: person.id }
  #   end
  #   it 'returns http success' do
  #     expect(response).to have_http_status(:success)
  #   end
  #   it 'assigns the person' do
  #     expect(assigns(:person)).to eq(person)
  #   end
  #   it "should render the form elements" do
  #     expect(page).to have_content(person.last_name)
  #     expect(page).to have_content(person.first_name)
  #     expect(page).to have_content(person.email)
  #   end
  # end

  # describe "DELETE #destroy" do
  #   it "destroys the requested select_option" do
  #     expect {
  #       delete :destroy, params: { id: person.id }
  #     }.to change(Person, :count).by(-1)
  #   end

  #   it "redirects to the field" do
  #     delete :destroy, params: { id: person.id }
  #     expect(response).to redirect_to(admin_persons_path)
  #   end
  # end
end
