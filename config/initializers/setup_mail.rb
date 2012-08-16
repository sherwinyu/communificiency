ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "contact@communificiency.com",
  :password             => "cmnfcy!co",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

