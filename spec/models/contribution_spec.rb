require 'spec_helper'

describe Contribution do
  let(:project) { FactoryGirl.create :project_with_rewards }
  let(:reward) { project.rewards.first }
  let(:user) { FactoryGirl.create :user }

  let (:contribution) do
    c = Contribution.new
    c.payment = FactoryGirl.build :payment
    c.user = user
    c.project = project
    c.amount = 15
    c
  end

  subject { contribution } 

  describe "attributes" do
    it { should respond_to :payment }
    it { should respond_to :user }
    it { should respond_to :project }
    it { should respond_to :reward }
    it { should respond_to :amount }
    its(:reward) { should be_nil }
  end

  describe "validations" do
    it { should validate_presence_of :amount }
    it { should validate_numericality_of(:amount).only_integer }
    describe "when amount is non positive" do
      before { contribution.amount = 0 }
      it { should have(1).errors_on(:amount) }
    end

    it { should validate_presence_of :payment }

    describe "when reward is non nil" do
      before do
        contribution.reward = reward
        contribution.amount = reward.minimum_contribution
      end

      it { should be_valid }

      it "should be invalid when amount is less than minimum contribution" do
        contribution.amount = reward.minimum_contribution - 1
        contribution.should have(1).errors_on(:amount)
      end

      it "should be valid when amount is >= than minimum contribution" do
        contribution.amount = reward.minimum_contribution
        contribution.should have(0).errors_on(:amount)
        contribution.should be_valid
      end

      describe "when reward belongs to another project" do
        before { @other_project = FactoryGirl.create :project_with_rewards }
        it { should_not allow_value(*@other_project.rewards).for(:reward).with_message(/not available for project/) }
      end

      describe "when limited_quantity is specified" do
        before do
          reward.limited_quantity = 3
        end

        describe "and limited_quantity is insufficient" do
          before do
            b = reward.contributions.create(user: user, project: project, amount: reward.minimum_contribution, payment: Payment.new)
            b2 = reward.contributions.create(user: user, project: project, amount: reward.minimum_contribution, payment: Payment.new)
            b3 = reward.contributions.create(user: user, project: project, amount: reward.minimum_contribution, payment: Payment.new)
          end
          it { should_not be_valid }
          it { should have(1).errors_on(:reward) }
        end
        it { should be_valid }
      end



    end # end non nil rewards

  end # end validations

  describe "associations" do 
    it { should belong_to(:reward) }
    it { should belong_to(:project) }
  end

end
