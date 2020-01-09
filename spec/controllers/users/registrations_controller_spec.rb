# frozen_string_literal: true

describe Users::RegistrationsController, type: :controller do
  context 'with valid attributes' do
    subject do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      post :create, params: { user: attributes_for(:user) }
    end

    it 'redirects to root path' do
      expect(subject).to redirect_to(root_path)
    end

    it 'creates a user' do
      subject
      expect(User.count).to eq 1
    end

    it 'sends a mail' do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'logs the user in' do
      subject
      expect(controller.current_user.nil?).to be false
    end
  end

  context 'with invalid attributes' do
    subject do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      post :create, params: { user: attributes_for(:user).except(:email) }
    end

    it 'renders new' do
      expect(subject).to render_template(:new)
    end

    it 'does not create a user' do
      subject
      expect(User.count).to eq 0
    end

    it 'does not send a mail' do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end

    it 'does not log the user in' do
      subject
      expect(controller.current_user.nil?).to be true
    end
  end
end
