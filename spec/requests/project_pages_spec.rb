require 'spec_helper'

describe 'Project pages' do
  subject { page }
  let (:project) { FactoryGirl.create :project_with_rewards }
  let (:user) { FactoryGirl.create :user }

  describe "show" do
    before { visit project_path(project) }
    it { should have_selector('title', text: project.name) }
  end

  describe "new contribution" do

    before do
      form_sign_in user
      visit new_project_contribution_path(project)
    end

    it { should have_selector('title', text: "Confirm contribution") }
    it { should have_selector('h2.contributionPaymentHeader', text: "Confirm your contribution") }
    it { should have_selector('h2.contributionPaymentHeader', text: "Choose your reward") }
    it { should have_selector('h2.contributionPaymentHeader', text: "Pay") }

    # TODO(syu) check selected
    it { should have_selector('#contribution_reward_id option', text: "No reward") }
    it { should have_selector('#contribution_reward_id option', text: project.rewards.first.name) }
    it { should have_selector('#contribution_reward_id option', text: project.rewards.second.name) }
    it { should have_selector('#contribution_reward_id option', text: project.rewards.third.name) }
    # it { should have_selector('div.reward_explanation.visible') }
    # it { should have_selector('div.reward_explanation', text: project.rewards.first.short_description) }

    describe "when not signed in" do
      before do
        form_sign_out
        visit new_project_contribution_path(project)
      end
      it { should display_sign_in_page }
    end

  end


=begin
  describe "edit when not signed in" do
    before { visit edit_user_registration_path }
    it { should flash_error "need to sign in" }
    it { should display_sign_in_page }
  end

  describe 'edit when signed in' do
    let(:user) { FactoryGirl.create(:user) }
    let(:submit) { "Update" }

    before do
      form_sign_in user
      visit edit_user_registration_path 
    end

    it { should have_selector('h1', text: "Edit settings") }

    describe "with valid information" do
      let(:new_name) { "new name" }
      let(:new_email) { "new@example.com" }

      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        # fill_in "Password", with: user.password
        fill_in "Current password", with: user.password
        click_button submit
      end

      # redirect to root
      it { should display_home_page }
      it { should flash_success "You updated your account successfully"}
      specify { user.reload.name.should == new_name }
      specify { user.reload.unconfirmed_email.should == new_email }
      # should not change old email
      specify { user.reload.email.should == user.email }

    end

    describe "with invalid information" do
      before { click_button submit }
      it { should flash_error "Please review the problems below" }
      # specify { response.should render_template('new') }
      # specify { response.should_not render_template('new') }
      # specify { response.should_not redirect_to(home_path) }
    end


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
        it { should flash_success "Welcome to Communificiency! You have signed up successfully." }

        # TODO syu Check if user signed in. We want user to be signed in after sign up

      end

    end
  end

=end
end

