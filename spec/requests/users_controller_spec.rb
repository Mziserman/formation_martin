# frozen_string_literal: true

RSpec.describe Admin::UsersController, type: :request do
  context 'while logged as an admin' do
    let(:user) { create :user }
    login_admin_user
    describe 'GET #log_as' do
      subject do
        get "/admin/users/#{user.id}/login_as"
      end

      it 'logs as user' do
        subject
        expect(@controller.current_user).to eq user
      end
    end
  end
end
