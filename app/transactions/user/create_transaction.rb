
class User::CreateTransaction
  include Dry::Transaction

  step :create
  tee :send_welcome_email

  private

  def create(input)
    if input[:user].save
      Success(input)
    else
      Failure(input)
    end
  end

  def send_welcome_email(input)
    UserMailer.with(input).welcome_email.deliver
    input[:user]
  end
end
