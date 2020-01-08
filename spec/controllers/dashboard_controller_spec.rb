# frozen_string_literal: true

describe DashboardController, type: :controller do
  context 'Not logged' do
    subject do
      get :index
    end

    it 'redirects to login page' do
      subject
      expect(subject).to redirect_to(new_user_session_url)
    end
  end

  context 'Logged' do
    login_user
    render_views

    subject do
      get :index
    end

    it 'has a link to current user profile' do
      subject
      expected_path = edit_user_registration_path
      expected_link_text = 'Éditer mon profil'
      expect(response.body).to include expected_path
      expect(response.body).to include expected_link_text
    end
  end
end
