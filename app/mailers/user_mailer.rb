class UserMailer < ApplicationMailer
  default from: 'martin@capsens.eu'

  def welcome_email
    @user = params[:user]
    @url  = 'localhost:3000/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end
