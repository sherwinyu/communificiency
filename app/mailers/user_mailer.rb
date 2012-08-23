class UserMailer < ActionMailer::Base
  default from: "team@communificiency.com"

  def welcome_email(user)
    @user = user
    @url = sign_in_url host: "communificiency.com"
    mail(to: user.email,
         subject: "Welcome to Communificiency!")
    # content_type: "text/html",
  end

  def contribution_confirmation(contribution)
    @contribution = contribution
    @user = @contribution.user
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(to: email_with_name,
         subject: "Communificiency contribution confirmation: #{@contribution.project.name}") do |format|
      format.text
      format.html
    end
  end


end
