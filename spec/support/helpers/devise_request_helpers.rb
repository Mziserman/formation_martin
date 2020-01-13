# frozen_string_literal: true

module DeviseRequestHelpers
  def login_user
    before(:each) do
      @current_user = FactoryBot.create(:user)
      sign_in @current_user
    end
  end

  def login_admin_user
    before(:each) do
      @current_admin_user = FactoryBot.create(:admin_user)
      sign_in @current_admin_user
    end
  end
end
