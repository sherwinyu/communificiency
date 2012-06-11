require 'spec_helper'

describe "StaticPages" do

  describe "Home Page" do
    it "should have the content 'communificiency'" do
      visit '/static_pages/home'
      page.should have_content('communificiency')
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      # get static_pages_index_path
      # response.status.should be(200)
    end
  end

  describe "Help page" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Help')
    end
  end

  describe "About page" do
    it "should have the content 'About Communificiency'" do
      visit '/static_pages/about'
      page.should have_content('About Communificiency') 
    end
  end

end
