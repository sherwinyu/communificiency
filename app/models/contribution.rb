class Contribution < ActiveRecord::Base
  attr_accessible :payment_id, :project_id, :reward_id, :user_id, :reward, :user, :amount
  belongs_to :payment
  belongs_to :user
  belongs_to :project
  belongs_to :reward

  validates_presence_of :amount
  validates_numericality_of :amount, greater_than: 0

  validates_each :reward, unless: Proc.new  { |contrib| contrib.project.nil?} do |record, attr, value|
    record.errors.add(attr, "Project (#{record.project}) does not have reward #{value}") unless record.project.rewards.include? value
  end

  validates_presence_of :reward

  validates_each :amount do |record, attr, value|
    record.errors.add(attr, "Contribution must be at least #{self.reward.minimum_contribution}, #{reward}'s minimum contribution") unless value > record.reward.minimum_contribution
  end

end
