class UserMailer < ActionMailer::Base
  default from: "notifications@communificiency.com"

  def welcome_email(user)
    @user = user
    @url = sign_in_url host: "communificiency.com"
    mail(to: user.email,
         subject: "Welcome to Communificiency!")
         # content_type: "text/html",
  end


end
