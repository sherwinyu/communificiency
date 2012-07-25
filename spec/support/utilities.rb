RSpec::Matchers.define :have_error_message do |message|
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
