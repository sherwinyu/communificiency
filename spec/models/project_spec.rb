require 'spec_helper'

describe Project do
  let(:project) { FactoryGirl.build :project }

  subject { project }

  describe "should be valid without any rewards" do
    it{ should have(0).rewards }
    it { should be_valid }
  end

  describe "attributes" do
    it { should respond_to :name }
    it { should respond_to :short_description }
    it { should respond_to :long_description }
    it { should respond_to :funding_needed }
    it { should respond_to :rewards }
    it { should respond_to :video }
    it { should respond_to :picture }
    it { should respond_to :contributions }
  end


  describe "validations" do
    describe "with non-dup name" do
      before { project.dup.save }
      it { should_not be_valid }
      it { should validate_uniqueness_of :name }
      it { should have(1).errors_on(:name) }
    end

    it { should validate_presence_of :name }
    it { should ensure_length_of(:name).is_at_most(60) }

    it { should validate_presence_of :short_description }

    describe "with long short_description" do
      before { project.short_description = "word "  * 201 }
      it { should have(1).errors_on(:short_description) }
    end

    it { should validate_presence_of :short_description }

    it { should validate_presence_of :funding_needed }
    it { should validate_numericality_of(:funding_needed).only_integer }
    describe "with non positive funding_needed" do
      before { project.funding_needed = -4 }
      it { should have(1).errors_on(:funding_needed) }
    end

  end


  describe "associations" do
    it { should have_many(:rewards) }
    it { should have_many(:contributions) }
    it { should have_many(:contributors).through(:contributions) }
    it { should belong_to(:proposer).class_name( :user )  }
    it { should accept_nested_attributes_for(:rewards).allow_destroy(true) }
  end

end
