require 'spec_helper'

describe Contribution do

  let(:project) { FactoryGirl.create :project_with_rewards }
  let(:user) { FactoryGirl.build :user }
  let(:contribution) do 
    c = FactoryGirl.build :contribution
    c.reward = project.rewards.first
    c.project = c.reward.project
    c.amount = c.reward.minimum_contribution
    c.user = FactoryGirl.build :user
    c
  end

  subject { contribution }

  it { should be_valid }

  describe "attributes" do
    it { should respond_to :user }
    it { should respond_to :reward } # refactor this ?
    it { should respond_to :amount }
    it { should respond_to :payment }
  end

  describe "validations" do
    it { should validate_presence_of :amount }
    it { should validate_numericality_of(:amount).only_integer }

    describe "when amount does not meet minimum_contribution" do
      before { contribution.amount = contribution.reward.minimum_contribution - 1 } 
      it { should_not be_valid }
      it { should have(1).error_on(:amount) }

      describe "when reward is nil" do
        before { contribution.reward = nil }
        it { should be_valid }
      end
    end

    describe "when reward isn't available for contribution's project" do
      before { @other_project = FactoryGirl.create :project_with_rewards  }
      it { should_not allow_value(*@other_project.rewards).for(:reward).with_message(/not available for project/) }

      describe "when project is nil" do
        before { contribution.project = nil }
        it { should allow_value(*@other_project.rewards).for(:reward).with_message(/not available for project/) }
        it { should_not be_valid }

      end

    end

  end

  describe "associations" do 
    it { should belong_to(:reward) }
    it { should belong_to(:project) }
  end

end
