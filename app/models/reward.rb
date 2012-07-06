class Reward < ActiveRecord::Base
  attr_accessible :long_description, :name, :project_id, :short_description, :minimum_contribution, :limited_quantity, :max_available, :current_available
  belongs_to :project
  has_many :contributions

  validates_presence_of :minimum_contribution 
  validates_numericality_of :minimum_contribution, message: "has to be a number"

  def to_s
    new_record? ? "New Reward" : "$ %.2f --  #{name} -- #{short_description}" % minimum_contribution
  end
end
