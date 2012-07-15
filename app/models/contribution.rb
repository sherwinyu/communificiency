class Contribution < ActiveRecord::Base
  attr_accessible :payment_id, :project_id, :reward_id, :user_id, :reward, :user, :amount
  belongs_to :payment
  belongs_to :user
  belongs_to :project
  belongs_to :reward

  validates_presence_of :amount
  validates_numericality_of :amount, greater_than: 0

  validates_each :reward, unless: Proc.new  { |contrib| contrib.project.nil?} do |contribution, attr, value|
    contribution.errors.add(attr, "Project (#{contribution.project}) does not have reward #{value}") unless contribution.project.rewards.include? value
  end

  validates_presence_of :reward

  validates_each :amount, unless: Proc.new{ |contrib| [contrib.amount.nil?,
                                                       contrib.reward.nil?,
                                                       contrib.reward.minimum_contribution.nil?].none? } do |contribution, attr, value|
    binding.pry
    reward = contribution.reward
    contribution.errors.add(attr,
                            "Contribution must be at least #{reward.minimum_contribution} #{reward}'s minimum contribution") unless value > reward.minimum_contribution
  end

end
