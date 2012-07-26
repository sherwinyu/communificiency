RSpec::Matchers.define :flash do |message|
  match do |page|
    page.should have_selector('div.alert', text: message)
  end
end

RSpec::Matchers.define :flash_success do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :flash_error do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :display_home_page do
  match do |page|
    page.should have_selector 'title', text: "Communificiency | Welcome" 
    page.should have_selector 'h1.bannerline', text: "awesome perks" 
  end
end

RSpec::Matchers.define :display_sign_in_page do
  match do |page|
    page.should have_selector('h1', text: 'Sign in') 
    page.should have_selector('title', text: 'Sign in') 
  end
end

RSpec::Matchers.define :ensure_signed_in do
  # visit about_path TODO why doesn't this work?
  # Actually fix this lol
  match do |page|
    page.should have_link ("Sign out") 
  end
end

RSpec::Matchers.define :ensure_signed_out do
  visit about_path
  match do |page|
    page.should have_link ("Sign in") 
    page.should have_link ("Sign up") 
  end
end

def form_sign_in(user)
  visit sign_in_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def form_signed_in?
  user_signed_in?
end

