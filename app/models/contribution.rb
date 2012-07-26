class Contribution < ActiveRecord::Base
  attr_accessible :payment_id, :project_id, :reward_id, :user_id, :reward, :user, :amount
  belongs_to :payment 
  belongs_to :user, inverse_of: :contributions
  belongs_to :project, inverse_of: :contributions
  belongs_to :reward, inverse_of: :contributions

  validates :user, presence: true

  validates :project, presence: true

  validates :reward,
    presence: {message: "must be selected"}
  validate :reward_belongs_to_project, unless: "project.nil?"

  validates  :amount,
    presence: true,
    numericality: {only_integer: true, greater_than: 0}
  validate :amount_meets_reward_minimum_contribution, unless: "reward.nil?"

  def amount_meets_reward_minimum_contribution
    errors[:amount] << "must be at least #{reward.minimum_contribution} for reward '#{reward}'" unless amount.to_i >= reward.minimum_contribution
  end



  def reward_belongs_to_project
    errors[:reward] << " #{reward} is not available for project #{project} " unless project.rewards.include? reward
  end








  #validates_each :reward, unless: Proc.new  { |contrib| contrib.project.nil?} do |contribution, attr, value|
    #contribution.errors.add(attr, " #{value} is not available for project #{contribution.project.name}") unless contribution.project.rewards.include? value
  #end

  #validates_presence_of :reward 

  #def validate_minimum_amount
    #errors.add :amount, "must be at least #{reward.minimum_contribution} for reward '#{reward.name}'" unless amount.to_i < reward.minimum_contribution
  #end

  #validates_each :amount, unless: Proc.new{ |contrib| [contrib.amount.nil?,
                                                       #contrib.reward.nil?,
                                                       #contrib.reward.minimum_contribution.nil?].any? } do |contribution, attr, value|
    #reward = contribution.reward
    #contribution.errors.add(attr,
                            #"must be at least #{reward.minimum_contribution} for reward '#{reward.name}'") unless value > reward.minimum_contribution
  #end




                                                       

end
