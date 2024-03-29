# frozen_string_literal: true

describe ActiveAdmin::Devise::SessionsController, type: :controller do
  context 'With valid login params' do
    let(:admin_user) { create :admin_user }

    subject do
      @request.env['devise.mapping'] = Devise.mappings[:admin_user]
      post :create, params: { admin_user: {
        email: admin_user.email,
        password: admin_user.password
      } }
    end

    it 'increments current admin_user sign_in_count on login' do
      expect { subject }.to(change { admin_user.reload.sign_in_count }.by(1))
    end
  end

  context 'With invalid login params' do
    let(:admin_user) { create :admin_user }

    subject do
      @request.env['devise.mapping'] = Devise.mappings[:admin_user]
      post :create, params: { admin_user: { email: admin_user.email, password: admin_user.password + 'non' } }
    end

    it 'increments current admin_user sign_in_count on login' do
      expect { subject }.not_to(change { admin_user.reload.sign_in_count })
    end
  end
end
