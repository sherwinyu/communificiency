class Contribution < ActiveRecord::Base
  attr_accessible :payment_id, :project_id, :reward_id, :user_id
  belongs_to :payment
  belongs_to :user
  belongs_to :project
  belongs_to :reward
end
