class Contribution < ActiveRecord::Base
  attr_accessible :payment_id, :project_id, :reward_id, :user_id, :reward, :user, :amount
  belongs_to :payment 
  belongs_to :user, inverse_of: :contributions
  belongs_to :project, inverse_of: :contributions
  belongs_to :reward, inverse_of: :contributions

  validates :user, presence: true

  validates :project, presence: true

  validate :reward_belongs_to_project, unless: "reward.nil? || project.nil?"

  validates  :amount,
    presence: true,
    numericality: {only_integer: true, greater_than: 0}
  validate :amount_meets_reward_minimum_contribution, unless: "reward.nil?"

  validates :payment,
    presence: true

  def amount_meets_reward_minimum_contribution
    errors[:amount] << "must be at least #{reward.minimum_contribution} for reward '#{reward}'" unless amount.to_i >= reward.minimum_contribution
  end

  def reward_belongs_to_project
    errors[:reward] << " '#{reward}' is not available for project '#{project}' " unless project.rewards.include? reward
  end

end
