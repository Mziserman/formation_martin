# frozen_string_literal: true

describe Users::SessionsController, type: :controller do
  context 'With valid login params' do
    let(:user) { create :user }

    subject do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      post :create, params: { user: { email: user.email, password: user.password } }
    end

    it 'increments current_user sign_in_count on login' do
      expect { subject }.to(change { user.reload.sign_in_count }.by(1))
    end
  end

  context 'With invalid login params' do
    let(:user) { create :user }

    subject do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      post :create, params: { user: { email: user.email, password: user.password + 'non' } }
    end

    it 'increments current_user sign_in_count on login' do
      expect { subject }.not_to(change { user.reload.sign_in_count })
    end
  end
end
