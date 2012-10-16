class Contribution < ActiveRecord::Base
  attr_accessible :payment, :payment_id, :project_id, :project, :reward_id, :user_id, :reward, :user, :amount, :status
  attr_accessor :placeholder, :payment_transaction_provider
  belongs_to :payment, inverse_of: :contribution
  belongs_to :user, inverse_of: :contributions
  belongs_to :project, inverse_of: :contributions
  belongs_to :reward, inverse_of: :contributions

  validates :user, presence: true

  validates :project, presence: true

  validate :reward_belongs_to_project, unless: "reward.nil? || project.nil?"

  validate :reward_quantity_sufficient, unless: "reward.nil? || project.nil?"

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

  def reward_quantity_sufficient
    errors[:reward] << " '#{reward}' is no longer available!" if (reward && reward.limited_quantity? && reward.quantity_remaining < 0)

  end

  def to_s
    "Contribution of $#{amount} to #{project} for #{reward || "(no reward)"}"
  end

end
