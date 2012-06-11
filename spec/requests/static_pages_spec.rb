require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the h1 'Communificiency'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'Communificiency')
    end

    it "should have the title 'Home'" do
      visit '/static_pages/home'
      page.should have_selector('title',
                        :text => "Communificiency")
    end

    it "should not have a custom title" do
      visit '/static_pages/home'
      page.should_not have_selector('title', text: '|')
    end
  end

  describe "Help page" do

    it "should have the h1 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end

    it "should have the title 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('title',
                        :text => "Communificiency | Help")
    end
  end

  describe "About page" do

    it "should have the h1 'About'" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'About')
    end

    it "should have the title 'About'" do
      visit '/static_pages/about'
      page.should have_selector('title',
                    :text => "Communificiency | About")
    end
  end
end
