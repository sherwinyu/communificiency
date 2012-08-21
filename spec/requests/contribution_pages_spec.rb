require 'spec_helper'

describe 'Contribution pages' do

  subject { page }

  let (:project) { FactoryGirl.create :project_with_rewards }
  let (:contribution) { FactoryGirl.create :contribution }
  let (:user) { FactoryGirl.create :user }
  let (:unconfirmed_user) { FactoryGirl.create :unconfirmed_user }

  before do 
    form_sign_in user
  end

  describe "new contribution" do

    before do
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

    describe "valid credit card information" do
      before do 
        fill_in "Card number", with: "4242"*4
      end


    end

    describe "when not signed in" do
      before do
        form_sign_out
        visit new_project_contribution_path(project)
      end
      it { should display_sign_in_page }
    end

    describe "when not confirmed" do
      before do
        form_sign_out
        form_sign_in unconfirmed_user
        visit new_project_contribution_path(project)
      end

      it { should flash_success "confirm" }
    end

  end
end
