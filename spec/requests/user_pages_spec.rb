require 'spec_helper'

describe 'User pages' do
  subject { page }

  describe 'edit' do
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_selector('title', text: user.name) }
    it { should have_selector('h1', text: user.name) }
  end




  describe "sign_up page" do
    before { visit sign_up_path }
    it { should have_selector('h1', text: 'Create your Communificiency Account') }
    it { should have_selector('title', text: 'Communificiency | Sign up') }
  end



  describe "sign_up process" do

    before { visit sign_up_path }
    let(:submit) { "Sign up" }

    describe "with invalid information" do
      before { click_button submit }

      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        # should redirect back to sign up
        it { should have_selector('h1', text: 'Create your Communificiency Account') }
        it { should have_selector('title', text: 'Communificiency | Sign up') }
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

      describe "after saving the user" do
        before { click_button submit }

        # it should redirect to root
        it { should display_home_page }
        it { should have_selector "div.alert-success", text: "Welcome to Communificiency! You have signed up successfully." }

        # TODO syu Check if user signed in. We want user to be signed in after sign up
        # user_signed_in?.should be_true

      end

    end
  end

end

