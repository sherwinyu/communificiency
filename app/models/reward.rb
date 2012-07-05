class Reward < ActiveRecord::Base
  attr_accessible :long_description, :name, :project_id, :short_description, :minimum_contribution, :limited_quantity, :max_available, :current_available
  belongs_to :project
  has_many :contributions

  def to_s
    new_record? ? "New Reward" : "#{minimum_contribution} \t #{name} \t #{short_description}"
  end
end
