require 'spec_helper'

describe Reward do
  let (:project) { FactoryGirl.create :project }
  let(:reward) do
    r = FactoryGirl.build :reward
    r.project = FactoryGirl.create :project
    r
  end

  subject do
    reward
  end

  it { should respond_to :name }
  it { should respond_to :short_description }
  it { should respond_to :long_description }
  it { should respond_to :minimum_contribution }
  it { should respond_to :project }
  it { should respond_to :limited_quantity }

  it { should be_valid }

  describe "validations" do
    it { should validate_presence_of :project }

    it { should validate_numericality_of(:limited_quantity).only_integer }
    describe "when limited_quantity is non positive" do
      before { reward.limited_quantity = 0 }
      it { should have(1).errors_on(:limited_quantity) }
    end

    it { should validate_presence_of :minimum_contribution }
    it { should validate_numericality_of(:minimum_contribution).only_integer }
    describe "when minimum_contribution is non positive" do
      before { reward.minimum_contribution = 0 }
      it { should have(1).errors_on(:minimum_contribution) }
    end

    it { should validate_presence_of :name }

    describe "when name is not unique to project" do
      before { reward.clone.save }
      it { should validate_uniqueness_of(:name).scoped_to(:project_id).with_message(/already exists/) }
      it { should_not be_valid }
    end

    describe "when name is a duplicate of another project's reward" do
      before do
        @other_reward = reward.dup
        @other_reward.project = FactoryGirl.create :project, name: "other project"
        @other_reward.save
      end
      its(:name) { should == @other_reward.name }
      it { should  be_valid }
    end

    it { should validate_presence_of :short_description }
    describe "when short_description is too long" do
      before { reward.short_description = "word " * 31 }
      it { should have(1).errors_on(:short_description) }
    end

    it { should validate_presence_of :long_description }
  end

  describe "associations" do
    it { should belong_to :project }
    it { should have_many :contributions }
  end

end
