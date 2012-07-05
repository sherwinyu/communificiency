class Contribution < ActiveRecord::Base
  attr_accessible :payment_id, :project_id, :reward_id, :user_id
  belongs_to :payment
  belongs_to :user
  belongs_to :project
  belongs_to :reward

  validates_each :reward, unless: Proc.new  { |contrib| contrib.project.nil?} do |record, attr, value|
    record.errors.add(attr, "Project (#{record.project}) does not have reward #{value}") unless record.project.rewards.include? value
  end

end
