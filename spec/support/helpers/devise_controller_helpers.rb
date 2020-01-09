# frozen_string_literal: true

module DeviseControllerHelpers
  def login_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @current_user = FactoryBot.create(:user)
      sign_in @current_user
    end
  end

  def login_admin_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:admin_user]
      @current_admin_user = FactoryBot.create(:admin_user)
      sign_in @current_admin_user
    end
  end
end
