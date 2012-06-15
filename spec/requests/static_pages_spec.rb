require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the h1 'Communificiency'" do
      visit root_path
      page.should have_selector('h1', :text => 'Communificiency')
    end

    it "should have the title 'Home'" do
      visit root_path
      page.should have_selector('title',
                                :text => "Communificiency")
    end

    it "should not have a custom title" do
      visit root_path
      page.should_not have_selector('title', text: '|')
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

  describe "About page" do

    it "should have the h1 'About'" do
      visit about_path
      page.should have_selector('h1', :text => 'About')
    end

    it "should have the title 'About'" do
      visit about_path 
      page.should have_selector('title',
                                :text => "Communificiency | About")
    end
  end

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
end
