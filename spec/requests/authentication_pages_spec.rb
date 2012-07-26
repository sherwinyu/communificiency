require 'spec_helper'

describe "Authentication" do


  subject { page }

  describe "sign_in page" do
    before { visit sign_in_path }

    it { should display_sign_in_page }
    it { should have_selector('h1', text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end

  describe 'sign_in process' do

    before { visit sign_in_path }

    describe 'when information invalid' do
      before { click_button "Sign in" }


      # it should re-render to sign in
      it { should have_selector('h1', text: 'Sign in') }
      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      # it shouldn't have the flash
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

      describe "with client side validation" do
        before do
          fill_in "Email", with: "asdf"
          fill_in "Password", with: "asdf"
          fill_in "Email", with: "asdf2"
        end

        # TODO test CSVs
        # it { should have_selector "span.help-inline"}

      end
    end



    describe 'when information is valid' do

      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      # user should be signed in 
      describe "user should be signed in" do
        before { visit about_path }
        it { should have_link 'Sign out' }
      end

      # should redirect (FORNOW) (TODO SYU) to home
      it { should display_home_page }
      it { should have_selector "div.alert-success", text: "Signed in" }

      describe "followed by sign out" do
        before { visit sign_out_path }

        it { should display_home_page }
        it { should have_selector "div.alert-success", text: "Signed out" }

        describe "user should be signed out " do
          before { visit about_path }
          it { should have_link 'Sign in' }
        end
      end

    end

  end

  describe "sign out when not signed in" do
    before { visit sign_out_path }
    # should redirect to home
    # it { should display_home_page }
    it { should_not have_selector "div.alert-success", text: "Welcome to Communificiency! You have signed up successfully." }
  end



end
