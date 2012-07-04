class Reward < ActiveRecord::Base
  attr_accessible :long_description, :name, :project_id, :short_description
  belongs_to :project
end
