ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "info@communificiency.com",
  :password             => "ch4ngethew0rld!",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

