class TweetsMailer < ActionMailer::Base
  default from: "tweets@anagorny.com"

  def verification(user)
    @user=user;
    mail to: user.email, subject:"Verification your e-mail"
  end

  def verificated(user)
  @user=user
    mail to: user.email, subject:"Welcom to Tweets Project!"
  end
end
