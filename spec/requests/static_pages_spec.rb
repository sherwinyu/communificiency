require 'spec_helper'

describe "Static pages" do


  subject { page }

  describe "Welcome page" do
    before { visit home_path }

    it { should have_selector('h1', text: "Communificiency") } 
  end


  describe "About page" do
    before { visit about_path }

    it { should have_selector('h1', text: "About") }
    it { should have_selector('title', text: "Communificiency | About") }
  end

  describe "coming_soon" do
    before { visit '/coming_soon' }

    it { should have_selector('h1', text: "Coming soon!") }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: 'About' 
    click_link "Sign up"
    page.should have_selector 'title', text: 'Sign up' 
  end


=begin
  describe "Contact page" do
    it "should have the h1 'Contact'" do
      visit contact_path
      page.should have_selector('h1', :text => 'Contact')
    end

    it "should have the title 'Contact'" do
      visit contact_path
      page.should have_selector('title',
                                :text => "Communificiency | Contact")
    end
  end

  describe "Help page" do

    it "should have the h1 'Help'" do
      visit help_path
      page.should have_selector('h1', :text => 'Help')
    end

    it "should have the title 'Help'" do
      visit help_path
      page.should have_selector('title',
                                :text => "Communificiency | Help")
    end
  end
=end
end
