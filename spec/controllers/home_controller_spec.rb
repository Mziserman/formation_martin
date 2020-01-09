describe HomeController, type: :controller do
  context 'Not logged' do
    render_views

    subject do
      get :index
    end

    it 'Says "Bienvenue !"' do
      subject
      expect(response.body).to include 'Bienvenue !'
    end
  end

  context 'Logged' do
    login_user
    render_views

    subject do
      get :index
    end

    it 'Says "Bienvenue #first_name #last_name !"' do
      subject
      expected = "Bienvenue #{@current_user.first_name} #{@current_user.last_name} !"
      expect(response.body).to include expected
    end
  end
end
