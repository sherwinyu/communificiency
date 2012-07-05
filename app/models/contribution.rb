class Contribution < ActiveRecord::Base
  attr_accessible :payment_id, :project_id, :reward_id, :user_id
end
