require 'spec_helper'

describe 'User pages' do
  subject { page }

  describe 'edit' do
  end

  describe "sign_up page" do
    before { visit sign_up_path }
    it { should have_selector('h1', text: 'Create your Communificiency Account') }
    it { should have_selector('title', text: 'Communificiency | Sign up') }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_selector('title', text: user.name) }
    it { should have_selector('h1', text: user.name) }
  end

  describe "sign_up process" do

    before { visit sign_up_path }

    let(:submit) { "Sign up" }
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "Example.User@email.com"
        fill_in "Password", with: "foobar"
        fill_in "Password confirmation", with: "foobar"
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end

  end
end

